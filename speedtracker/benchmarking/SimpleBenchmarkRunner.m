classdef SimpleBenchmarkRunner < BenchmarkRunner
    %SIMPLEBENCHMARKRUNNER BenchmarkRunner whose benchmarks are general functions
    %    A benchmark can be any function that takes no arguments and returns some kind of result. In addition,
    %    you must supply (pass into the constructor) a binary function compareFunction that says whether two
    %    results are identical.

    properties
        logger;
        % COMPAREFUNCTION function used to compare the results of a benchmark between two snapshots
        compareFunction;
    end

    properties (GetAccess=public, SetAccess=private)
        % Results per benchmark as an associative array.
        % We are collecting the benchmarks for each combination of benchmark and snapshot, so we store them
        % as an associative array of associative arrays, with the inner arrays indexed by snapshot ID.
        % Each element is a struct containing the property 'time' and either 'value' or 'error'.
        results;
    end

    properties (Constant, Access=private)
        BENCHMARKS_FOLDER = 'benchmarks';
    end

    methods
        function this = SimpleBenchmarkRunner(logger, compareFunction)
            %SIMPLEBENCHMARKRUNNER Construct an instance of this class
            %    compareFunction is the function used for comparing the results of two benchmarks, returning
            %    true if they are identical and false if not.
            this.logger = logger;
            this.compareFunction = compareFunction;
            this.results = {};
        end

        %% BenchmarkRunner Interface
        function this = init(this, benchmarkIDs)
            %INIT check that all of the specified benchmarks exist and take 0 arguments
            this.results = {};
            for i = 1:length(benchmarkIDs)
                this.checkBenchmark(benchmarkIDs{i});
                this.results = setOption(this.results, benchmarkIDs{i}, {});
            end
        end

        function this = runBenchmark(this, currentSnapshotID, benchmarkID)
            %RUNBENCHMARK Run a benchmark and store its results.
            % Exceptions:
            % BenchmarkRunner.ERROR_BENCHMARK_NOT_LOADED if the benchmark was not previously loaded with init(), either
            %     because the benchmark was not in the list or because init() was not called at all.
            if ~hasOption(this.results, benchmarkID)
                throw(MException(BenchmarkRunner.ERROR_BENCHMARK_NOT_LOADED, sprintf( ...
                    'benchmark %s was not loaded with init()', benchmarkID)));
            end
            benchmarkFunction = str2func(benchmarkID);
            resultsForBenchmark = getOption(this.results, benchmarkID);
            tic
            try
                value = benchmarkFunction();
                time = toc;
                result = struct('value', value, 'time', time);
            catch error
                time = toc;
                this.logger.error(sprintf('exception in benchmark %s, continuing with other benchmarks', benchmarkID));
                result = struct('error', error, 'time', time);
            end
            resultsForBenchmark = setOption(resultsForBenchmark, currentSnapshotID, result);
            this.results = setOption(this.results, benchmarkID, resultsForBenchmark);
        end

        function results = getResults(this)
            %GETRESULTS return the results of benchmarking so far
            results = this.results;
        end

        function tab = makeTable(this, results)
            %MAKETABLE convert benchmarking results (from getResults) to a table
            % with the columns 'benchmarkID', 'snapshotID', 'time', 'changed', and 'error'.
            % 'error' is true if an error occurred during benchmarking. 'changed' is true if the result
            % is different from the result for the first snapshot, meaning either one errored and the other did not,
            % or both completed successfully and this.compareFunction returns false.
            % See also COMPAREFUNCTION
            tables = mapOptionlist( ...
                @(benchmark, resultsForBenchmark) this.makeTableForBenchmark(benchmark, resultsForBenchmark), ...
                results);
            tab = vertcat(this.makeEmptyTable(0), tables{:}); % that empty table covers the case where there are no benchmarks
        end

        %% Querying Benchmarks
        function benchmarks = listBenchmarks(this)
            %LISTBENCHMARKS List all available benchmarks.
            % To be precise, all .m files that
            % 1. are located in <tempDir>/benchmarks
            % 2. take no arguments 
            % are treated as benchmarks.
            benchmarks = {};
            benchmarksDir = this.getBenchmarksDirectory();
            contents = dir(benchmarksDir);
            contents = contents(arrayfun(@(file) exist(file.name, 'file')==2, contents));
            functions = contents(arrayfun(@(file) endsWith(file.name, '.m'), contents));
            for i=1:length(functions)
                fileName = functions(i).name;
                funcName = extractBefore(fileName, strlength(fileName) - 1);
                if (nargin(str2func(funcName)) == 0)
                    benchmarks{end+1} = funcName;
                end
            end
        end
    end

    methods (Access=private)
        function checkBenchmark(this, benchmarkID)
            benchmarkFile = fullfile(this.getBenchmarksDirectory(), sprintf('%s.m', benchmarkID));
            if exist(benchmarkFile, 'file') ~= 2
                throw(MException(BenchmarkRunner.ERROR_BAD_BENCHMARK, sprintf( ...
                        'no benchmark with id %s found in %s', ...
                        benchmarkID, this.getBenchmarksDirectory())));
            end
            benchmarkFunctionName = benchmarkID;
            benchmarkFunction = str2func(benchmarkFunctionName);
            try
                nArgs = nargin(benchmarkFunction);
            catch error
                throw(MException(BenchmarkRunner.ERROR_BAD_BENCHMARK, sprintf( ...
                    'benchmark %s is not a function: %s', benchmarkID, error.message)));
            end
            if nArgs ~= 0
                throw(MException( ...
                    BenchmarkRunner.ERROR_BAD_BENCHMARK, sprintf( ...
                        'benchmark %s should be parameterless, but actually expects %s arguments', ...
                        benchmarkID, nargin(benchmarkFunction))));
            end
        end

        function directory = getBenchmarksDirectory(~)
            speedtrackerConfig = ConfigProvider.getSpeedtrackerConfig();
            directory = fullfile(speedtrackerConfig.tempDir, SimpleBenchmarkRunner.BENCHMARKS_FOLDER);
        end

        function tab = makeTableForBenchmark(this, benchmarkID, results)
            nSnapshots = length(results) / 2;
            tab = this.makeEmptyTable(nSnapshots);
            for i = 1:(length(results) / 2)
                snapshotID = results{2*i - 1};
                result = results{2*i};
                tab(i, {'benchmark', 'snapshot', 'time'}) = {benchmarkID, snapshotID, result.time};
                tab(i, 'error') = {isfield(result, 'error')};
                tab(i, 'changed') = {~this.compareResults(results{2}, result)};
            end
        end

        function tab = makeEmptyTable(~, nRows)
            tab = table('Size', [nRows 5], ...
                'VariableNames', {'benchmark', 'snapshot', 'time', 'changed', 'error'}, ...
                'VariableTypes', {'cellstr', 'cellstr', 'double', 'logical', 'logical'});
        end

        function areEqual = compareResults(this, result1, result2)
            if isfield(result1, 'error') && isfield(result2, 'error')
                areEqual = true;
            elseif isfield(result1, 'value') && isfield(result2, 'value')
                areEqual = this.compareFunction(result1.value, result2.value);
            else
                areEqual = false;
            end
        end
    end
end

