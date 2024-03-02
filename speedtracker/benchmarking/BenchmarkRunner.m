classdef BenchmarkRunner
    %BENCHMARKRUNNER Runs benchmarks across various snapshots.

    properties (GetAccess=public, SetAccess=private)
        speedtrackerConfig;
        logger;
        % Cell array of the benchmarks to run. Since we have to run them all, load a new snapshot, then run them
        % again, they are set in the constructor instead of being passed to runBenchmarks, and each call to
        % runBenchmarks modifies the BenchmarkRunner.
        benchmarks;
        % Cell array of the benchmarks' results, always of the same length as benchmarks.
        results;
    end

    properties (Constant)
        ERROR_BENCHMARK_NOT_FOUND = "BenchmarkRunner:benchmarkNotFound";
        ERROR_BAD_BENCHMARK = "BenchmarkRunner:badBenchmark";
    end

    properties (Constant, Access=private)
        BENCHMARKS_FOLDER = "benchmarks";
    end

    methods
        function this = BenchmarkRunner(speedtrackerConfig, logger, benchmarks)
            this.speedtrackerConfig = speedtrackerConfig;
            this.logger = logger;
            this.benchmarks = benchmarks;
            this.results = cell(1, length(benchmarks));
            for i=1:length(benchmarks)
                this.results{i} = BenchmarkResult(benchmarks(i));
            end
        end
        function this = runBenchmarks(this, snapshotID)
            initPaths();
            for i=1:length(this.benchmarks)
                benchmark = this.loadBenchmark(this.benchmarks(i));
                result = this.runBenchmark(benchmark, snapshotID);
                resultsSoFar = this.results{i};
                this.results{i} = resultsSoFar.merge(result);
            end
        end
    end

    methods (Access=private)

        % Run a single benchmark and return a BenchmarkResult containing only its results, which can then be
        % added to the results from the other snapshots for that particular benchmark.
        % If an exception occurs during the solving of the ODE, return a failed
        function benchmarkResult = runBenchmark(this, benchmark, snapshotID)
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
            benchmarkFile = fullfile(this.speedtrackerConfig.tempDir, BenchmarkRunner.BENCHMARKS_FOLDER, benchmarkID + ".m");
            if exist(benchmarkFile, 'file') ~= 2
                throw(MException(BenchmarkRunner.ERROR_BENCHMARK_NOT_FOUND, "no benchmark with id " + benchmarkID));
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