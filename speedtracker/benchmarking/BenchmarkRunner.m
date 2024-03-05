classdef (Abstract) BenchmarkRunner
    %BENCHMARKRUNNER Runs benchmarks across various snapshots. All IFDIFF-specific functionality
    % should be hidden behind this interface, so that Speedtracker can be used with other
    % libraries. If you do try to use this with another library, UserConfig will have to change too, and possibly
    % other code, too, so be careful.

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

        % Run a single benchmark and store its results, which can later be retrieved with getResults.
        % Exceptions:
        %    if an exception occurs during the solving of the ODE, do not simply crash but return a valid result
        %    object that is recognizable as failure.
        % _May_ throw an error with the following identifiers in the given cases:
        % ERROR_BENCHMARK_NOT_LOADED if the given benchmark was not previously loaded with init(), either because
        %     it was not among the list passed or because init() was never called.
        this = runBenchmark(this, currentSnapshotID, benchmarkID)

        % Return the results of all benchmarking across all snapshots. There are three degrees of freedom: Snapshots,
        % Benchmarks, and metrics. An abstract representation would be a third-order tensor. But tensors are confusing,
        % so instead this must return a cell array of structs each containing the results for one benchmark.
        % R1 each element of the returned cell array must be compatible with makeTable()
        results = getResults(this)

        % Make a MATLAB table from a single benchmark's result. Since getResults returns the results of all benchmarks,
        % you can do something like `cellfun(@(result) this.makeTable(result, this.getResults())`
        % R1 the tables obtained from each result must have similar enough columns that they can be concatenated
        % with vertcat, even if not all benchmarks were run with the same set of snapshots
        tab = makeTable(this, result)
    end
end
