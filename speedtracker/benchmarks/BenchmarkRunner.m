classdef BenchmarkRunner
    %UNTITLED Runs benchmarks across various snapshots. 

    properties (GetAccess=public, SetAccess=private)
        logger;
        % Cell array of the benchmarks to run. Since we have to run them all, load a new snapshot, then run them
        % again, they are set in the constructor instead of being passed to runBenchmarks, and each call to
        % runBenchmarks modifies the BenchmarkRunner.
        benchmarks;
        % Cell array of the benchmarks' results, always of the same length as benchmarks.
        results;
    end

    methods
        function this = BenchmarkRunner(logger, benchmarks)
            this.logger = logger;
            this.benchmarks = benchmarks;
            this.results = cell(1, length(benchmarks));
            for i=1:length(benchmarks)
                this.results{i} = BenchmarkResult(benchmarks{i}.id);
            end
        end
        function this = runBenchmarks(this, snapshotID)
            initPaths();
            for i=1:length(this.benchmarks)
                result = this.runBenchmark(this.benchmarks{i}, snapshotID);
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
                                                             'options', benchmark.odeOptions);
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
    end

end