classdef (Abstract) BenchmarkRunner
    %BENCHMARKRUNNER Runs benchmarks across various snapshots. All IFDIFF-specific functionality
    % should be hidden behind this interface, so that Speedtracker can be used with other
    % libraries

    properties (Constant)
        ERROR_BAD_BENCHMARK = "BenchmarkRunner:badBenchmark"
        ERROR_BENCHMARK_NOT_LOADED = "BenchmarkRunner:benchmarkNotLoaded"
    end

    methods (Abstract)
        % List all available benchmarks. Return a vector of their IDs, which must be strings
        benchmarks = listBenchmarks(this)

        % Prepare to run the provided benchmarks, given as a list of their IDs. For example, loading benchmarks from
        % disk or preallocating a return structure.
        % Must throw errors with the following identifiers in the given cases:
        % ERROR_BAD_BENCHMARK if one of the provided benchmarks does not exist or is faulty
        this = init(this, benchmarkIDs)

        % Run a single benchmark and return a BenchmarkResult containing only its results, which can then be
        % added to the results from the other snapshots for that particular benchmark.
        % Exceptions:
        %    if an exception occurs during the solving of the ODE, do not simply crash but return a valid result
        %    object that is recognizable as failed.
        % _May_ throw an error with the following identifiers in the given cases:
        % ERROR_BENCHMARK_NOT_LOADED if the given benchmark was not previously loaded with init(), either because
        %     it was not among the list passed or because init() was never called.
        this = runBenchmark(this, currentSnapshotID, benchmarkID)

        % Return the results of all benchmarking across all snapshots. There are three degrees of freedom: Snapshots,
        % Benchmarks, and metrics. An abstract representation would be a third-order tensor. But tensors are confusing,
        % so instead this must return a cell array of structs each containing the results for one benchmark.
        % R1 each element of the returned cell array must be compatible with makeTable()
        results = getResults(this)

        % Make a MATLAB table from a benchmark's result.
        % R1 the tables must have similar enough columns that they can be concatenated with vertcat
        tab = makeTable(this, result)
    end
end
