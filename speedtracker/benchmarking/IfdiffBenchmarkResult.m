classdef IfdiffBenchmarkResult
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
        % real time (using tic and toc) taken for the integration
        % (including prepareDataHandleForIntegration), 1xN double
        time;
        % Exception that caused the benchmark run to fail, or [] if everything went well.
        error;
    end

    methods
        function this = IfdiffBenchmarkResult(benchmarkID, snapshotID, xEnd, switchingPoints, time, error)
            % You can also call this with no results to initialize an empty list.
            if (nargin == 1)
                assert(isa(benchmarkID, "string"), "IfdiffBenchmarkResult member benchmark is of type string");
                this.benchmarkID = benchmarkID;
                this.snapshotID = string([]);
                this.xEnd = double([]);
                this.switchingPoints = cell([]);
                this.time = double([]);
                this.error = [];
                return;
            end
            assert(isa(benchmarkID, "string"),   "IfdiffBenchmarkResult member benchmark is of type string");
            assert(isa(snapshotID, "string"),    "IfdiffBenchmarkResult member snapshotID is of type string");
            assert(isa(xEnd, "double"),          "IfdiffBenchmarkResult member xEnd is of type double");
            assert(isa(switchingPoints, "cell"), "IfdiffBenchmarkResult member switchingPoints is of type cell");
            assert(isa(time, "double"),          "IfdiffBenchmarkResult member time is of type double");
            this.benchmarkID = benchmarkID;
            this.snapshotID = snapshotID;
            this.xEnd = xEnd;
            this.switchingPoints = switchingPoints;
            this.time = time;
            this.error = error;
        end

        % Add the result of one or more testing runs to this list by merging the member arrays.
        function this = merge(this, other)
            assert(this.benchmarkID == other.benchmarkID, "other IfdiffBenchmarkResult is from the same benchmark");
            this.snapshotID = [this.snapshotID other.snapshotID];
            this.xEnd = [this.xEnd other.xEnd];
            this.switchingPoints = [this.switchingPoints other.switchingPoints];
            this.time = [this.time other.time];
            this.error = [this.error other.error];
        end

        % Put this IfdiffBenchmarkResult into a table with the columns' names matching the fields of IfdiffBenchmarkResult.
        % Most of the fields are just transposed. The exceptions are benchmarkID, which is repeated in every
        % row, and xEnd, where each entry is pressed into a 1xd row inside a 1x1 cell array. This allows concatenating
        % multiple IfdiffBenchmarkResults' tables into one.
        function tab = toTable(this)
            benchmarkConfig = IfdiffBenchmarkRunner.getConfig();
            n = length(this.snapshotID); % number of snapshots
            idColumn = repelem(this.benchmarkID, n)';
            % Transpose xEnd, then convert each row into a cell. This allows us to merge tables
            xEndCell = mat2cell(this.xEnd', ones(size(this.xEnd, 2), 1));
            xEndChanged = this.makeChangedFlags(benchmarkConfig.XEndTol, xEndCell, "changed", "");
            tab = table(idColumn, this.snapshotID', xEndCell, xEndChanged, this.switchingPoints', this.time', this.error', ...
                'VariableNames', ["benchmarkID", "snapshotID", "xEnd", "xEnd changed", "switchingPoints", "time", "error"]);
        end
    end

    methods (Access=private)
        % Given a cell vector of length n containing doubles, create a logical array that describes, for each entry,
        % whether it differs from the previous. More precisely, given a cell array c, create an Nx1 array d,
        % where d(i) is 0 iff c(i) and c(i-1) are equal up to tolerance tol, and c(0) is 0. Equality is determined
        % using ismembertol. If entries have different sizes, they are, of course, considered different.
        % Optionally, pass the arguments yesVal and noVal to use instead of 1 and 0 in the result array.
        function changed = makeChangedFlags(~, tol, c, yesVal, noVal)
            changedFlags = zeros(length(c), 1);
            for i=1:length(changedFlags)-1
                if size(c{i}) ~= size(c{i+1})
                    changedFlags(i+1) = 1;
                else
                    changedFlags(i+1) = ~all(all(ismembertol(c{i}, c{i+1}, tol)));
                end
            end
            if nargin == 2
                changed = changedFlags;
                return;
            end
            answers = [yesVal; noVal];
            changed = answers(2 - changedFlags);
        end
    end
end

