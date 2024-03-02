classdef IfdiffBenchmarkRunner < BenchmarkRunner
    %BENCHMARKRUNNER Runs benchmarks across various snapshots.

    properties (Access=public)
        speedtrackerConfig;
        logger;
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
        function this = IfdiffBenchmarkRunner(speedtrackerConfig, logger)
            this.speedtrackerConfig = speedtrackerConfig;
            this.logger = logger;
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
                this.results(benchmark.id) = BenchmarkResult(benchmark.id);
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
    end

    methods (Access=private)

        % Run a single benchmark and return a BenchmarkResult containing only its results, which can then be
        % added to the results from the other snapshots for that particular benchmark.
        % If an exception occurs during the solving of the ODE, return a failed
        function benchmarkResult = runBenchmarkInternal(this, snapshotID, benchmark)
            tic;
            try
                datahandle = prepareDatahandleForIntegration(convertStringsToChars(benchmark.rhs), ...
                                                             'solver', benchmark.solver, ...
                                                             'options', benchmark.options);
                sol = solveODE(datahandle, benchmark.tSpan, benchmark.x0, benchmark.p);
            catch error
                time = toc;
                this.logger.error("exception in benchmark " + benchmark.id + ", continuing with other benchmarks");
                benchmarkResult = BenchmarkResult( ...
                    benchmark.id, snapshotID, NaN(size(benchmark.x0), "double"), {[]}, time, {error});
                return;
            end

            time = toc;
            xEnd = sol.y(:,end);
            switchingPoints = {sol.switches};
            benchmarkResult = BenchmarkResult(benchmark.id, snapshotID, xEnd, switchingPoints, time, {[]});
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
            benchmarkFile = fullfile(this.speedtrackerConfig.tempDir, IfdiffBenchmarkRunner.BENCHMARKS_FOLDER, benchmarkID + ".m");
            if exist(benchmarkFile, 'file') ~= 2
                throw(MException(IfdiffBenchmarkRunner.ERROR_BENCHMARK_NOT_FOUND, "no benchmark with id " + benchmarkID));
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
                throw(MException(BenchmarkRunner.ERROR_BAD_BENCHMARK, "bad benchmark: " + benchmarkID).addCause(error));
            end
        end
        function validateBenchmark(~, benchmark)
            assert(isfield(benchmark, "id"),         "benchmark has member id");
            assert(isa(benchmark.id, "string"),      "benchmark member id is of type string");
            assert(isfield(benchmark, "rhs"),        "benchmark has member rhs");
            assert(isa(benchmark.rhs, "string"),     "benchmark member rhs is of type string");
            assert(isfield(benchmark, "solver"),     "benchmark has member solver");
            assert(isa(benchmark.solver, "string"),  "benchmark member solver is of type string");
            assert(isfield(benchmark, "tSpan"),      "benchmark has member tSpan");
            assert(isa(benchmark.tSpan, "double"),   "benchmark member tSpan is of type double");
            assert(isfield(benchmark, "x0"),         "benchmark has member x0");
            assert(isa(benchmark.x0, "double"),      "benchmark member x0 is of type double");
            assert(isfield(benchmark, "p"),          "benchmark has member p");
            assert(isa(benchmark.p, "double"),       "benchmark member p is of type double");
            assert(isfield(benchmark, "options"),    "benchmark has member options");
            assert(isa(benchmark.options, "struct"), "benchmark member options is of type struct");
        end
    end
end