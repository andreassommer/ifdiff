classdef IfdiffBenchmarkRunner < BenchmarkRunner
    %BENCHMARKRUNNER Runs benchmarks across various snapshots.

    properties (Access=public)
        logger;
    end

    properties (Constant)
        ERROR_CONFIG_NOT_SET = 'IfdiffBenchmarkRunner:configNotSet'
    end

    properties (Access=private)
        % associative array of benchmarks
        benchmarks;
        % original benchmark IDs passed, in order to keep track of the order
        benchmarkIDList;
        % associative array of benchmark results
        results;
    end

    properties (Constant, Access=private)
        BENCHMARKS_FOLDER = 'benchmarks';
    end

    methods
        function this = IfdiffBenchmarkRunner(logger)
            this.logger = logger;
        end

        function benchmarks = listBenchmarks(this)
            % List all available benchmarks.
            % To be precise, all .m files in
            % <tempDir>/benchmarks that contain functions with no arguments are treated as benchmarks, and their function
            % names used as benchmark IDs. So make sure there is no garbage lying around in that folder!
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


        function this = init(this, benchmarkIDs)
            % For a list of benchmark IDs, load each one and validate that they are correct and complete
            % Exceptions:
            % BenchmarkRunner.ERROR_BAD_BENCHMARK if any benchmark is malformed or cannot be found
            this.benchmarkIDList = benchmarkIDs;
            this.benchmarks = {};
            this.results = {};
            for i=1:length(benchmarkIDs)
                benchmark = this.loadBenchmark(benchmarkIDs{i});
                this.benchmarks = setOption(this.benchmarks, benchmark.id, benchmark);
                this.results    = setOption(this.results, benchmark.id, IfdiffBenchmarkResult(benchmark.id));
            end
        end

        function this = runBenchmark(this, currentSnapshotID, benchmarkID)
            % Run a benchmark and store its results.
            % Exceptions:
            % BenchmarkRunner.ERROR_BENCHMARK_NOT_LOADED if the benchmark was not previously loaded with init(), either
            %     because the benchmark was not in the list or because init() was not called at all.
            if ~hasOption(this.benchmarks, benchmarkID)
                throw(MException(BenchmarkRunner.ERROR_BENCHMARK_NOT_LOADED, sprintf( ...
                    'benchmark %s was not loaded with init()', benchmarkID)));
            end
            initPaths();
            result = this.runBenchmarkInternal(currentSnapshotID, getOption(this.benchmarks, benchmarkID));
            resultsSoFar = getOption(this.results, benchmarkID);
            this.results = setOption(this.results, benchmarkID, resultsSoFar.merge(result));
        end

        function results = getResults(this)
            % Get the results from all the benchmarking runs so far.
            results = cell(1, length(this.benchmarkIDList));
            for i=1:length(this.benchmarkIDList)
                benchmarkID = this.benchmarkIDList(i);
                results{i} = getOption(this.results, benchmarkID);
            end
        end

        function tab = makeTable(~, result)
            % Put a IfdiffBenchmarkResult into a table with the columns' names matching the fields of IfdiffBenchmarkResult.
            % delegated to IfdiffBenchmarkResult#toTable
            tab = result.toTable();
        end
    end

    methods (Static)
        function config = getConfig()
            % Return the IfdiffBenchmarkConfig, which contains user-settable configuration parameters specific to IFDIFF
            config = IfdiffBenchmarkRunner.getSetConfig();
        end
        function setConfig(newConfig)
            % Set the IfdiffBenchmarkConfig, which contains user-settable  configuration parameters specific to IFDIFF
            IfdiffBenchmarkRunner.getSetConfig(newConfig);
        end
    end
    methods (Static, Access=private)
        function config = getSetConfig(newConfig)
            persistent benchmarkConfig;
            if (nargin == 0 && isempty(benchmarkConfig))
                throw(MException(IfdiffBenchmarkRunner.ERROR_CONFIG_NOT_SET, 'IfdiffBenchmarkConfig not set'));
            elseif (nargin ==0)
                config = benchmarkConfig;
            else
                benchmarkConfig = newConfig;
            end
        end
    end

    methods (Access=private)

        function benchmarkResult = runBenchmarkInternal(this, snapshotID, benchmark)
            % Run a single benchmark and return a IfdiffBenchmarkResult containing only its results.
            % These can then be added to the results from the other snapshots for that particular benchmark.
            % If an exception occurs during the solving of the ODE, return a failed benchmark
            tic;
            try
                datahandle = prepareDatahandleForIntegration(benchmark.rhs, ...
                                                             'solver', benchmark.solver, ...
                                                             'options', benchmark.options);
                sol = solveODE(datahandle, benchmark.tSpan, benchmark.x0, benchmark.p);
            catch error
                time = toc;
                this.logger.error(sprintf('exception in benchmark %s, continuing with other benchmarks', benchmark.id));
                benchmarkResult = IfdiffBenchmarkResult( ...
                    benchmark.id, snapshotID, NaN(size(benchmark.x0), 'double'), {[]}, time, {error});
                return;
            end

            time = toc;
            xEnd = sol.y(:,end);
            switchingPoints = {sol.switches};
            benchmarkResult = IfdiffBenchmarkResult(benchmark.id, snapshotID, xEnd, switchingPoints, time, {[]});
        end

        function benchmark = makeBenchmark(~, id, rhs, solver, tSpan, x0, p, options)
            benchmark = struct( ...
                'id', id, ...
                'rhs', rhs, ...
                'solver', solver, ...
                'tSpan', tSpan, ...
                'x0', x0, ...
                'p', p, ...
                'options', options ...
            );
        end

        function benchmark = loadBenchmark(this, benchmarkID)
            benchmarkFile = fullfile(this.getBenchmarksDirectory(), sprintf('%s.m', benchmarkID));
            if exist(benchmarkFile, 'file') ~= 2
                throw(MException(BenchmarkRunner.ERROR_BAD_BENCHMARK, sprintf( ...
                        'no benchmark with id %s', benchmarkID)));
            end
            benchmarkFunctionName = benchmarkID;
            benchmarkFunction = str2func(benchmarkFunctionName);
            if nargin(benchmarkFunction) ~= 0
                throw(MException( ...
                    BenchmarkRunner.ERROR_BAD_BENCHMARK, sprintf( ...
                        'benchmark function should be parameterless, but actually expects %s arguments', ...
                        nargin(benchmarkFunction))));
            end
            benchmark = benchmarkFunction();
            benchmark.id = benchmarkID;
            try
                this.validateBenchmark(benchmark)
            catch error
                message = sprintf('bad benchmark %s: %s', benchmarkID, error.message);
                throw(MException(BenchmarkRunner.ERROR_BAD_BENCHMARK, message).addCause(error));
            end
        end
        function validateBenchmark(~, benchmark)
            assert(isfield(benchmark, 'id'),         'benchmark lacks member id');
            assert(isa(benchmark.id, 'char'),      'benchmark member id is not of type char');
            assert(isfield(benchmark, 'rhs'),        'benchmark lacks member rhs');
            assert(isa(benchmark.rhs, 'char'),     'benchmark member rhs is not of type char');
            assert(isfield(benchmark, 'solver'),     'benchmark lacks member solver');
            assert(isa(benchmark.solver, 'char'),  'benchmark member solver is not of type char');
            assert(isfield(benchmark, 'tSpan'),      'benchmark lacks member tSpan');
            assert(isa(benchmark.tSpan, 'double'),   'benchmark member tSpan is not of type double');
            assert(isfield(benchmark, 'x0'),         'benchmark lacks member x0');
            assert(isa(benchmark.x0, 'double'),      'benchmark member x0 is not of type double');
            assert(isfield(benchmark, 'p'),          'benchmark lacks member p');
            assert(isa(benchmark.p, 'double'),       'benchmark member p is not of type double');
            assert(isfield(benchmark, 'options'),    'benchmark lacks member options');
            assert(isa(benchmark.options, 'struct'), 'benchmark member options is not of type struct');
        end

        function directory = getBenchmarksDirectory(~)
            speedtrackerConfig = ConfigProvider.getSpeedtrackerConfig();
            directory = fullfile(speedtrackerConfig.tempDir, IfdiffBenchmarkRunner.BENCHMARKS_FOLDER);
        end
    end
end