classdef FunctionBenchmarkRunner < BenchmarkRunner
    %FUNCTIONBENCHMARKRUNNER BenchmarkRunner whose benchmarks are general functions
    %    A benchmark can be any function that takes no arguments and returns some kind of result. In addition,
    %    you must supply a function compareFunction that says whether two
    %    results are identical. For each benchmark and snapshot, the runner runs the benchmark n times, determined
    %    by UserConfig.NIterations, stores the result of the benchmark (which
    %    is a function, remember) and a list of how long each run took.
    % See also USERCONFIG

    properties
        logger;
        % COMPAREFUNCTION function used to compare the results of a benchmark between two snapshots
        compareFunction;
    end

    properties (GetAccess=public, SetAccess=private)
        % Results per benchmark as an associative array. A key is a benchmark's ID, a value is another
        % associative array mapping snapshot IDs to results for that benchmark-snapshot pair.
        % Each result, finally, is a struct with the results for that pair. It has either the properties
        % 'error' (if a benchmarking run threw an error) or the properties
        % 'value' (the output of the benchmark's function) and 'time', an array
        % of the time each run took with UserConfig.NIterations elements.
        % So, more abstractly, it is a binary map, containing a result for each pair of benchmark and snapshot.
        % If NIterations is 0, each benchmark's result is an empty cell array.
        results;
    end

    properties (Constant, Access=private)
        BENCHMARKS_FOLDER = 'benchmarks';
    end

    methods
        function this = FunctionBenchmarkRunner(logger, compareFunction)
            %FUNCTIONBENCHMARKRUNNER Construct an instance of this class
            %    compareFunction is the function used for comparing the results of two benchmarks, returning
            %    true if they are identical and false if not.
            this.logger = logger;
            this.compareFunction = compareFunction;
            this.results = {};
        end

        %% BenchmarkRunner Interface
        function this = init(this, benchmarkIDs)
            %INIT check that all of the specified benchmarks exist and take 0 arguments, and initialize an empty
            %    result list for each benchmark
            this.results = {};
            for i = 1:length(benchmarkIDs)
                this.checkBenchmark(benchmarkIDs{i});
                this.results = setOption(this.results, benchmarkIDs{i}, {});
            end
        end

        function this = runBenchmark(this, snapshotID, benchmarkID)
            %RUNBENCHMARK Run a benchmark and store its results.
            % The benchmark is run multiple times, defined by UserConfig.NIterations, and the times averaged.
            % The value field of the result is kept from the first benchmarking run. Unless there were exceptions,
            % in which case the last errored result is kept.
            % Exceptions:
            % BenchmarkRunner.ERROR_BENCHMARK_NOT_LOADED if the benchmark was not previously loaded with init(), either
            %     either because the benchmark was not in the list or because init() was not called at all.
            %     If the benchmark itself throws an exception, this method will continue and simply save a
            %     "failed" result.
            % See also USERCONFIG
            if ~hasOption(this.results, benchmarkID)
                throw(MException(BenchmarkRunner.ERROR_BENCHMARK_NOT_LOADED, sprintf( ...
                    'benchmark %s was not loaded with init()', benchmarkID)));
            end

            resultsofBenchmark = getOption(this.results, benchmarkID);
            n = ConfigProvider.getUserConfig().NIterations;
            if n == 0
                return;
            end

            % run benchmark once to avoid first-time initialization and cache misses skewing the results
            this.runBenchmarkOnce(benchmarkID);

            time = zeros(1, n);
            value = [];
            for i=1:n
                result = this.runBenchmarkOnce(benchmarkID);
                if isfield(result, 'error')
                    this.logger.error(sprintf('exception in benchmark %s, continuing with other benchmarks', benchmarkID));
                    resultsofBenchmark = setOption(resultsofBenchmark, snapshotID, result);
                    this.results = setOption(this.results, benchmarkID, resultsofBenchmark);
                    return;
                end
                this.logger.debug(sprintf('iteration %3d took %9.6fs', i, result.time));
                time(i) = result.time;
                if isempty(value)
                    value = result.value;
                end
            end
            resultsofBenchmark = setOption(resultsofBenchmark, snapshotID, struct('value', value, 'time', time));
            this.results = setOption(this.results, benchmarkID, resultsofBenchmark);
        end

        function results = getResults(this)
            %GETRESULTS return the results of benchmarking
            results = this.results;
        end

        function tab = makeTable(this, results)
            %MAKETABLE convert benchmarking results (from getResults) to a table
            % with the columns 'benchmarkID', 'snapshotID', 'changed', 'error', 'timeMean', 'timeStd', and 'timeMedian'.
            % 'error' is true if an error occurred during any benchmarking run.
            % 'changed' is true if the result
            % is different from the result for the first snapshot, meaning either one errored and the other did not,
            % or both completed successfully, but this.compareFunction returns false.
            % 'timeMean', 'timeStd', and 'timeMedian' are the mean, standard deviation, and median of the middle
            % 50% of the times taken. That is, we ignore lowest and highest quarter of the results to avoid
            % unusually fast or slow runs distorting our average.
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
            % 1. are located in <tempDir>/benchmarks (no subfolder)
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

        function result = runBenchmarkOnce(this, benchmarkID)
            benchmarkFunction = str2func(benchmarkID);
            ticID = tic();
            try
                value = benchmarkFunction();
                time = toc(ticID);
                result = struct('value', value, 'time', time);
            catch error
                time = toc(ticID);
                result = struct('error', error, 'time', time);
            end
        end

        function directory = getBenchmarksDirectory(~)
            speedtrackerConfig = ConfigProvider.getSpeedtrackerConfig();
            directory = fullfile(speedtrackerConfig.tempDir, FunctionBenchmarkRunner.BENCHMARKS_FOLDER);
        end

        function tab = makeTableForBenchmark(this, benchmarkID, results)
            nSnapshots = length(results) / 2;
            tab = this.makeEmptyTable(nSnapshots);
            for i = 1:nSnapshots
                snapshotID = results{2*i - 1};
                result = results{2*i};
                tab(i, {'benchmark', 'snapshot'}) = {benchmarkID, snapshotID};
                tab(i, 'error') = {isfield(result, 'error')};
                tab(i, 'changed') = {~this.compareResults(results{2}, result)};
                if isfield(result, 'error')
                    tab(i, {'timeMean', 'timeStd', 'timeMedian'}) = {-1, -1, -1};
                else
                    [timeMean, timeStd, timeMedian] = this.getTimeStatistics(result.time);
                    tab(i, {'timeMean', 'timeStd', 'timeMedian'}) = {timeMean, timeStd, timeMedian};
                end
            end
        end

        function tab = makeEmptyTable(~, nRows)
            tab = table('Size', [nRows 7], ...
                'VariableNames', {'benchmark', 'snapshot', 'changed', 'error', 'timeMean', 'timeStd', 'timeMedian'}, ...
                'VariableTypes', {'cellstr', 'cellstr', 'logical', 'logical', 'double', 'double', 'double'});
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

        function [meanVal, stdVal, medianVal] = getTimeStatistics(~, timeArray)
            switch length(timeArray)
                case {0, 1, 2, 3}
                    stats = {mean(timeArray), std(timeArray), median(timeArray)};
                otherwise
                    quartiles = quantile(timeArray, [1/4 1/2 3/4]);
                    topThreeQuarters = timeArray(timeArray > quartiles(1));
                    middleHalf = topThreeQuarters(topThreeQuarters <= quartiles(3));
                    stats = {mean(middleHalf), std(middleHalf), quartiles(2)};
            end
            meanVal = stats{1};
            stdVal = stats{2};
            medianVal = stats{3};
        end
    end
end

