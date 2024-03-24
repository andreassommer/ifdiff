classdef SpeedtrackerRunner
    %SPEEDTRACKERRUNNER Runner for the main benchmarking functionality.
    % Receives a SnapshotLoader and a BenchmarkRunner and performs the benchmarking and collecting of results.

    properties
        logger;
        snapshotLoader;
        benchmarkRunner;
    end

    methods
        function obj = SpeedtrackerRunner(logger, snapshotLoader, benchmarkRunner)
            obj.logger = logger;
            obj.snapshotLoader = snapshotLoader;
            obj.benchmarkRunner = benchmarkRunner;
        end

        function this = run(this, snapshots, benchmarks)
            % Run a set of benchmarks across a set of snapshots.
            % The snapshots are either 1xN array of strings passed
            % through commandConfig.Snapshots, or all snapshots that SnapshotLoader#listSnapshots returns. The
            % benchmarks are either a 1xN array of strings passed through commandConfig.Benchmarks, or all benchmarks
            % returned by BenchmarkRunner#listBenchmarks.
            % The basic procedure is:
            % 1. determine snapshots and benchmarks
            % 2. initialize the BenchmarkRunner and its benchmarks
            % 3. save project state with the SnapshotLoader
            % 4. check out each snapshot in sequence. for each snapshot, run all benchmarks over it and collect the
            %    results
            % The results can then be retrieved (see getBenchmarkResults)
            % Exceptions:
            % E1 one of the benchmarks is faulty or nonexistent: throw BenchmarkRunner.ERROR_BAD_BENCHMARK
            % E2 cannot save project state because a save is already present: throw SnapshotLoader.ERROR_SAVED_STATE_PRESENT
            % E3 cannot save project state for other reasons: throw SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE
            %    as per the API of SnapshotLoader, there may be another exception attached as a cause.
            % E4 one of the snapshots is faulty or nonexistent: throw SnapshotLoader.ERROR_BAD_SNAPSHOT_ID
            % Exceptions during benchmark execution should be caught by the BenchmarkRunner, as per its API.
            % Unexpected exceptions may occur, of course, but only in really, well, unexpected cases.

            % Initialize the benchmarks
            this.benchmarkRunner = this.benchmarkRunner.init(benchmarks);

            % Save project state so we can check out snapshots
            this.snapshotLoader = this.snapshotLoader.saveProjectState();

            % The meat: check out each snapshot, run all benchmarks over it, then proceed to the next snapshot.
            % Everything is in a try block so we can at least call restore project state no matter what goes wrong.
            try
                this.logger.info(sprintf('running benchmarks %s', strjoin(benchmarks, ', ')));
                this.logger.info(sprintf('  on snapshots %s', strjoin(snapshots, ', ')));
                for i=1:length(snapshots)
                    this.logger.info(sprintf('loading snapshot %s', snapshots{i}));
                    this.snapshotLoader = this.snapshotLoader.loadSnapshot(snapshots{i});
                    for j=1:length(benchmarks)
                        this.benchmarkRunner = this.benchmarkRunner.runBenchmark(snapshots{i}, benchmarks{j});
                    end
                    this.logger.info('ran all benchmarks');
                end
            catch error
                this.logger.error('error while running benchmarks, restoring project state');
                try
                    this.snapshotLoader = this.snapshotLoader.restoreProjectState();
                    this.logger.info('successfully restored project state');
                catch restoreError
                    this.logger.error('failed to restore state. try checking out previous branch and');
                    this.logger.error('    running restore-state command. If this fails, consult the instructions.');
                    this.logger.error('    restoring state failed because of:');
                    this.logger.error(restoreError.getReport());
                end
                rethrow(error);
            end
            this.snapshotLoader = this.snapshotLoader.restoreProjectState();
        end


        function prettyResults = getBenchmarkResults(this)
            % Convert this.benchmarkRunner's results depending on the configuration value of OutputType.
            % See Configuration#OutputType for explanation on the available options.
            results = this.benchmarkRunner.getResults();
            userConfig = ConfigProvider.getUserConfig();
            outputType = userConfig.OutputType;
            switch lower(outputType)
                case 'ntables'
                    prettyResults = cellfun(@(benchmarkResult) this.benchmarkRunner.makeTable(benchmarkResult), ...
                        results, ...
                        'UniformOutput', false);
                case 'onetable'
                    tables = cellfun(@(benchmarkResult) this.benchmarkRunner.makeTable(benchmarkResult), ...
                        results, ...
                        'UniformOutput', false);
                    prettyResults = vertcat(tables{:});
                otherwise
                    prettyResults = results;
            end
        end
    end
end

