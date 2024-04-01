classdef (Abstract) BenchmarkRunner
    %BENCHMARKRUNNER Runs benchmarks across various snapshots.
    % All IFDIFF-specific functionality
    % should be hidden behind this interface, so that Speedtracker can be used with other
    % libraries.

    properties (Constant)
        ERROR_BAD_BENCHMARK = 'BenchmarkRunner:badBenchmark'
        ERROR_BENCHMARK_NOT_LOADED = 'BenchmarkRunner:benchmarkNotLoaded'
    end

    methods (Abstract)
        % Prepare to run the provided benchmarks, given as a list of their IDs.
        % For example, loading benchmarks from disk or preallocating a return structure.
        % Must throw errors with the following identifiers in the given cases:
        % BenchmarkRunner.ERROR_BAD_BENCHMARK if one of the provided benchmarks does not exist or is faulty
        this = init(this, benchmarkIDs)

        % Run a single benchmark and store its results, which can later be retrieved with getResults.
        % Exceptions:
        %    if an exception occurs during the solving of the ODE, do not simply crash but return a valid result
        %    object that is recognizable as failure.
        % _May_ throw an error with the following identifiers in the given cases:
        % BenchmarkRunner.ERROR_BENCHMARK_NOT_LOADED if the given benchmark was not previously loaded with
        %     init(), either because it was not among the list passed or because init() was never called.
        this = runBenchmark(this, currentSnapshotID, benchmarkID)

        % Return the results of all benchmarking across all snapshots
        results = getResults(this)

        % Make a MATLAB table from the results returned by getResults
        tab = makeTable(this, results)
    end
end
