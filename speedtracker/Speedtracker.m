classdef Speedtracker
    %SPEEDTRACKER Runner for the main benchmarking functionality. Receives a SnapshotLoader and a BenchmarkRunner
    % and performs the main benchmarking.
    
    properties
        logger;
        snapshotLoader;
        benchmarkRunner;
    end
    
    methods
        function obj = Speedtracker(logger, snapshotLoader, benchmarkRunner)
            obj.logger = logger;
            obj.snapshotLoader = snapshotLoader;
            obj.benchmarkRunner = benchmarkRunner;
        end

        % Run a set of benchmarks across a set of snapshots. The snapshots are either 1xN array of strings passed
        % through commandConfig.Snapshots, or all snapshots that SnapshotLoader#listSnapshots returns. The
        % benchmarks are either a 1xN array of strings passed through commandConfig.Benchmarks, or all benchmarks
        % returned by BenchmarkRunner#listBenchmarks.
        function this = run(this, commandConfig)
            if isfield(commandConfig, "Snapshots")
                snapshots = commandConfig.Snapshots;
            else
                snapshots = this.snapshotLoader.listSnapshots();
            end
            if isfield(commandConfig, "Benchmarks")
                benchmarks = commandConfig.Benchmarks;
            else
                benchmarks = this.benchmarkRunner.listBenchmarks();
            end

            try
                this.benchmarkRunner = this.benchmarkRunner.init(benchmarks);
            catch initError
                switch initError.identifier
                    case BenchmarkRunner.ERROR_BAD_BENCHMARK
                        throw(MException(UserCommand.ERROR_EXPECTED_EXCEPTION, initError.message));
                    otherwise
                        rethrow(initError);
                end
            end

            try
                this.snapshotLoader = this.snapshotLoader.saveProjectState();
            catch savingError
                switch savingError.identifier
                    case SnapshotLoader.ERROR_SAVED_STATE_PRESENT
                        throw(MException(UserCommand.ERROR_EXPECTED_EXCEPTION, ...
                            "cannot save project state as a saved state is already present" + SystemUtil.lineSep() + ...
                            " you may try the restore-state command to restore the project and consume the saved state."));
                    case SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE
                        if isempty(savingError.cause)
                            rethrow(savingError);
                        end
                        innerError = savingError.cause{1};
                        if ismember(innerError.identifier, [GitSnapshotManager.ERROR_DETACHED_HEAD, ...
                                GitSnapshotManager.ERROR_STAGED_CHANGES_PRESENT])
                            throw(MException(UserCommand.ERROR_EXPECTED_EXCEPTION, innerError.message));
                        else
                            rethrow(savingError);
                        end
                    otherwise
                        rethrow(savingError);
                end
            end

            % Put everything in a try block to ensure that we can restore
            % state if anything goes wrong
            try
                this.logger.info("running benchmarks " + strjoin(benchmarks, ", "));
                this.logger.info("  on snapshots " + strjoin(snapshots, ", "));
                for i=1:length(snapshots)
                    this.logger.info("loading snapshot " + snapshots(i));
                    this.snapshotLoader = this.snapshotLoader.loadSnapshot(snapshots(i));
                    for j=1:length(benchmarks)
                        this.benchmarkRunner = this.benchmarkRunner.runBenchmark(snapshots(i), benchmarks(j));
                    end
                    this.logger.info("ran all benchmarks");
                end
            catch error
                this.logger.error("error while running benchmarks, restoring project state");
                try
                    this.snapshotLoader = this.snapshotLoader.restoreProjectState();
                    this.logger.info("successfully restored project state");
                catch restoreError
                    this.logger.error("failed to restore state. try checking out previous branch and");
                    this.logger.error("    running restore-state command. If this fails, consult the instructions.");
                    this.logger.error("    restoring state failed because of:");
                    this.logger.error(restoreError.getReport());
                end
                rethrow(error);
            end
            this.snapshotLoader = this.snapshotLoader.restoreProjectState();
        end


        % Convert this.benchmarkRunner's results depending on the configuration value of OutputType. See
        % Configuration#OutputType for explanation on the available options.
        function prettyResults = getBenchmarkResults(this)
            results = this.benchmarkRunner.getResults();
            userConfig = ConfigProvider.getUserConfig();
            outputType = userConfig.OutputType;
            switch lower(outputType)
                case "ntables"
                    prettyResults = cellfun(@(benchmarkResult) this.benchmarkRunner.makeTable(benchmarkResult), ...
                        results, ...
                        'UniformOutput', false);
                case "onetable"
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

