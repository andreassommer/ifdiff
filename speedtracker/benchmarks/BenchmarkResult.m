classdef BenchmarkResult
    %BENCHMARKRESULT Result of running a benchmark on a number of snapshots, accumulating a list of
    % results. This class follows the "struct-of-arrays over array-of-structs" convention, so all fields
    % except the benchmark itself are vectors, representing the results of multiple benchmarking runs.
    % A failed benchmarking run can also be represented with this class. In case of an
    % error, the field xEnd should be set to NaN in the correct dimensions (which can be found through the
    % Benchmark object's initial values field), switchingPoints should be empty, and
    % snapshotID and time should be set correctly. If nothing went wrong, error should be [].

    properties (Access=public)
        % The ID of the benchmark being run. Unlike all the other properties, this one is scalar, since we want to
        % represent running _one_ benchmark on _multiple_ snapshots
        benchmarkID;
        % IDs of the snapshots tested, 1xN string
        snapshotID;
        % value of the solution at the end of the integration horizon, dxN double (d=dimension of xEnd)
        xEnd;
        % switching points, 1xN cell (a matrix array would not work since different snapshots might have different
        % numbers of switching points. Hopefully not, but we cannot exclude it), each cell containing a 1xN 
        % array of the switching points.
        switchingPoints;
        % real time (using tic and toc) taken for the integration (including prepareDataHandleForIntegration)
        time;
        % Exception that caused the benchmark run to fail, or [] if everything went well.
        error;
    end

    methods
        function this = BenchmarkResult(benchmarkID, snapshotID, xEnd, switchingPoints, time, error)
            % You can also call this with no results to initialize an empty list.
            if (nargin == 1)
                assert(isa(benchmarkID, "string"), "BenchmarkResult member benchmark is of type string");
                this.benchmarkID = benchmarkID;
                this.snapshotID = string([]);
                this.xEnd = double([]);
                this.switchingPoints = cell([]);
                this.time = double([]);
                this.error = [];
                return;
            end
            assert(isa(benchmarkID, "string"),   "BenchmarkResult member benchmark is of type string");
            assert(isa(snapshotID, "string"),    "BenchmarkResult member snapshotID is of type string");
            assert(isa(xEnd, "double"),          "BenchmarkResult member xEnd is of type double");
            assert(isa(switchingPoints, "cell"), "BenchmarkResult member switchingPoints is of type cell");
            assert(isa(time, "double"),          "BenchmarkResult member time is of type double");
            this.benchmarkID = benchmarkID;
            this.snapshotID = snapshotID;
            this.xEnd = xEnd;
            this.switchingPoints = switchingPoints;
            this.time = time;
            this.error = error;
        end

        % Add the result of one or more testing runs to this list by merging the member arrays.
        function this = merge(this, other)
            assert(this.benchmarkID == other.benchmarkID, "other BenchmarkResult is from the same benchmark");
            this.snapshotID = [this.snapshotID other.snapshotID];
            this.xEnd = [this.xEnd other.xEnd];
            this.switchingPoints = [this.switchingPoints other.switchingPoints];
            this.time = [this.time other.time];
            this.error = [this.error other.error];
        end
    end
end

