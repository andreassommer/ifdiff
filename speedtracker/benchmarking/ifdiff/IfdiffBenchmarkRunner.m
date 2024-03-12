classdef IfdiffBenchmarkRunner < BenchmarkRunner
    %BENCHMARKRUNNER Runs benchmarks across various snapshots.

    properties (Access=public)
        logger;
    end

    properties (Constant)
        ERROR_CONFIG_NOT_SET = "IfdiffBenchmarkRunner:configNotSet"
    end

    properties (Access=private)
        % dictionary of benchmarks
        benchmarks;
        % original benchmark IDs passed, in order to keep track of the order
        benchmarkIDList;
        % dictionary of benchmark results
        results;
    end

    properties (Constant, Access=private)
        BENCHMARKS_FOLDER = "benchmarks";
    end

    methods
        function this = IfdiffBenchmarkRunner(logger)
            this.logger = logger;
        end

        % List all available benchmarks. To be precise, all .m files in
        % <tempDir>/benchmarks that contain functions with no arguments are treated as benchmarks, and their function
        % names used as benchmark IDs. So make sure there is no garbage lying around in that folder!
        function benchmarks = listBenchmarks(this)
            benchmarks = [];
            benchmarksDir = this.getBenchmarksDirectory();
            contents = dir(benchmarksDir);
            contents = contents(arrayfun(@(file) exist(file.name, "file")==2, contents));
            functions = contents(arrayfun(@(file) endsWith(file.name, ".m"), contents));
            for i=1:length(functions)
                fileName = string(functions(i).name);
                funcName = extractBefore(fileName, strlength(fileName) - 1);
                if (nargin(str2func(funcName)) == 0)
                    benchmarks = [benchmarks funcName];
                end
            end
        end

        % For a list of benchmark IDs, load each one and validate that they are correct and complete
        % Exceptions:
        % BenchmarkRunner.ERROR_BAD_BENCHMARK if any benchmark is malformed or cannot be found
        function this = init(this, benchmarkIDs)
            this.benchmarkIDList = benchmarkIDs;
            this.benchmarks = dictionary;
            this.results = dictionary;
            for i=1:length(benchmarkIDs)
                benchmark = this.loadBenchmark(benchmarkIDs(i));
                this.benchmarks(benchmark.id) = benchmark;
                this.results(benchmark.id) = IfdiffBenchmarkResult(benchmark.id);
            end
        end

        % Run a benchmark and store its results.
        % Exceptions:
        % BenchmarkRunner.ERROR_BENCHMARK_NOT_LOADED if the benchmark was not previously loaded with init(), either
        %     because the benchmark was not in the list or because init() was not called at all.
        function this = runBenchmark(this, currentSnapshotID, benchmarkID)
            if ~isKey(this.benchmarks, benchmarkID)
                throw(MException(BenchmarkRunner.ERROR_BENCHMARK_NOT_LOADED, ...
                    "benchmark " + benchmarkID + " was not loaded with init()"));
            end
            initPaths();
            result = this.runBenchmarkInternal(currentSnapshotID, this.benchmarks(benchmarkID));
            resultsSoFar = this.results(benchmarkID);
            this.results(benchmarkID) = resultsSoFar.merge(result);
        end

        % Get the results from all the benchmarking runs so far.
        function results = getResults(this)
            results = cell(1, length(this.benchmarkIDList));
            for i=1:length(this.benchmarkIDList)
                benchmarkID = this.benchmarkIDList(i);
                results{i} = this.results(benchmarkID);
            end
        end

        % Put a IfdiffBenchmarkResult into a table with the columns' names matching the fields of IfdiffBenchmarkResult.
        % delegated to IfdiffBenchmarkResult#toTable
        function tab = makeTable(~, result)
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
                throw(MException(IfdiffBenchmarkRunner.ERROR_CONFIG_NOT_SET, "IfdiffBenchmarkConfig not set"));
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
            % If an exception occurs during the solving of the ODE, return a failed
            tic;
            try
                datahandle = prepareDatahandleForIntegration(convertStringsToChars(benchmark.rhs), ...
                                                             'solver', benchmark.solver, ...
                                                             'options', benchmark.options);
                sol = solveODE(datahandle, benchmark.tSpan, benchmark.x0, benchmark.p);
            catch error
                time = toc;
                this.logger.error("exception in benchmark " + benchmark.id + ", continuing with other benchmarks");
                benchmarkResult = IfdiffBenchmarkResult( ...
                    benchmark.id, snapshotID, NaN(size(benchmark.x0), "double"), {[]}, time, {error});
                return;
            end

            time = toc;
            xEnd = sol.y(:,end);
            switchingPoints = {sol.switches};
            benchmarkResult = IfdiffBenchmarkResult(benchmark.id, snapshotID, xEnd, switchingPoints, time, {[]});
        end

        function benchmark = makeBenchmark(~, id, rhs, solver, tSpan, x0, p, options)
            benchmark = struct( ...
                "id", id, ...
                "rhs", rhs, ...
                "solver", solver, ...
                "tSpan", tSpan, ...
                "x0", x0, ...
                "p", p, ...
                "options", options ...
            );
        end

        function benchmark = loadBenchmark(this, benchmarkID)
            benchmarkFile = fullfile(this.getBenchmarksDirectory(), benchmarkID + ".m");
            if exist(benchmarkFile, 'file') ~= 2
                throw(MException(BenchmarkRunner.ERROR_BAD_BENCHMARK, "no benchmark with id " + benchmarkID));
            end
            benchmarkFunctionName = benchmarkID;
            benchmarkFunction = str2func(benchmarkFunctionName);
            if nargin(benchmarkFunction) ~= 0
                throw(MException( ...
                    BenchmarkRunner.ERROR_BAD_BENCHMARK, ...
                    "benchmark function should be parameterless, but actually expects %s arguments", ...
                    nargin(benchmarkFunction)));
            end
            benchmark = benchmarkFunction();
            benchmark.id = benchmarkID;
            try
                this.validateBenchmark(benchmark)
            catch error
                message = "bad benchmark " + benchmarkID + ": " + error.message;
                throw(MException(BenchmarkRunner.ERROR_BAD_BENCHMARK, message).addCause(error));
            end
        end
        function validateBenchmark(~, benchmark)
            assert(isfield(benchmark, "id"),         "benchmark lacks member id");
            assert(isa(benchmark.id, "string"),      "benchmark member id is not of type string");
            assert(isfield(benchmark, "rhs"),        "benchmark lacks member rhs");
            assert(isa(benchmark.rhs, "string"),     "benchmark member rhs is not of type string");
            assert(isfield(benchmark, "solver"),     "benchmark lacks member solver");
            assert(isa(benchmark.solver, "string"),  "benchmark member solver is not of type string");
            assert(isfield(benchmark, "tSpan"),      "benchmark lacks member tSpan");
            assert(isa(benchmark.tSpan, "double"),   "benchmark member tSpan is not of type double");
            assert(isfield(benchmark, "x0"),         "benchmark lacks member x0");
            assert(isa(benchmark.x0, "double"),      "benchmark member x0 is not of type double");
            assert(isfield(benchmark, "p"),          "benchmark lacks member p");
            assert(isa(benchmark.p, "double"),       "benchmark member p is not of type double");
            assert(isfield(benchmark, "options"),    "benchmark lacks member options");
            assert(isa(benchmark.options, "struct"), "benchmark member options is not of type struct");
        end

        function directory = getBenchmarksDirectory(~)
            speedtrackerConfig = ConfigProvider.getSpeedtrackerConfig();
            directory = fullfile(speedtrackerConfig.tempDir, IfdiffBenchmarkRunner.BENCHMARKS_FOLDER);
        end
    end
end