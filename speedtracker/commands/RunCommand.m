classdef RunCommand < UserCommand
    methods
        function this = RunCommand()
        end

        function name = getName(~)
            name = "run";
        end

        function msg = shortHelp(this)
            msg = sprintf("speedtracker(""%s"", <varargin>)", this.getName());
        end

        function msg = longHelp(this)
            msg = strjoin([
                sprintf("speedtracker(""%s"", <varargin>)", this.getName()), ...
                "    Run benchmarks across various snapshots and collect the results.", ...
                "    speedtracker does this by successively checking out each snapshot,", ...
                "    running every supplied benchmark in the context of that snapshot,", ...
                "    collecting the results in a format TBD, ", ...
                "    and finally restoring the state of the repository before the command was invoked.", ...
                "    ", ...
                "    <varargin> is a list of key-value pairs, e.g. ", ...
                sprintf("    speedtracker(""%s"", 'SnapshotFile', 'snapshots.txt')", this.getName()), ...
                "    with the accepted keys being:", ...
                "    Snapshots: a 1xN string array of snapshot IDs to test in the order specified.", ...
                "    SnapshotFile: the name of a file containing snapshot IDs, separated by newlines, to test in the order specified", ...
                "      if Snapshots and SnapshotFile are present, whichever came last wins out.", ...
                "    Benchmarks: TBD", ...
                "    Config: TBD", ...
                "    ", ...
                "    If something goes wrong and the state is not restored, you may try the", ...
                "    restore-state command to restore it."
            ], SystemUtil.lineSep());
        end

        % Process arguments, producing a struct of the form:
        % {
        %   [Snapshots: 1xN string]      % only one of Snapshots and SnapshotFile can be present
        %   [SnapshotFile: simpleString]
        %   [Benchmarks: any]
        %   [Config: any]
        % }
        % where simpleString means either a 1x1 string array or a 1xN character array.
        function commandConfig = handleArgs(~, argCell)
            commandConfig = struct();
            if length(argCell) > 2
                % ignore excess last argument
                if mod(length(argCell), 2) == 1; endIx = length(argCell)-1; else; endIx = length(argCell)-2; end;
                for i=2:2:endIx
                    key = argCell{i};
                    value = argCell{i+1};
                    switch(key)
                        case "Snapshots"
                            if ~isstring(value)
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, ...
                                        "parameter Snapshots expects a string vector, but got type " + class(value)));
                            end
                            if length(size(value)) ~= 2 || (size(value, 1) ~= 1)
                                dimStr = strjoin(string(size(value)), " x ");
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, ...
                                        "parameter Snapshots expects a 1xN string vector, but got dimensions " + dimStr));
                            end
                            commandConfig.Snapshots = value;
                        case "Benchmarks"
                            commandConfig.Benchmarks = value;
                        case "Config"
                            commandConfig.Config = value;
                        otherwise
                    end
                end
            end
        end

        function message = execute(~, logger, commandConfig)
            speedtrackerConfig = ConfigProvider.getSpeedtrackerConfig();
            snapshotManager = GitSnapshotManager(speedtrackerConfig, logger);
            defaultBenchmark = Benchmark("defaultBenchmark", ...
                    "canonicalExampleRHS", func2str(@ode45), [0 20], [1; 0], 5.437, odeset('AbsTol', 1e-8, 'RelTol', 1e-6));
            runner = BenchmarkRunner(logger, {defaultBenchmark});
            try
                snapshotManager.saveProjectState();
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
            try
                if isfield(commandConfig, "Snapshots")
                    snapshots = commandConfig.Snapshots;
                else
                    snapshots = snapshotManager.listSnapshots();
                end
                logger.info("running benchmarks " + strjoin(cellfun(@(b) b.id, runner.benchmarks), ", "));
                logger.info("  on snapshots " + strjoin(snapshots, ", "));
                message = "";
                for i=1:length(snapshots)
                    logger.info("loading snapshot " + snapshots(i));
                    snapshotManager.loadSnapshot(snapshots(i));
                    runner = runner.runBenchmarks(snapshots(i));
                    logger.info("ran all benchmarks");
                end
                for j=1:length(runner.benchmarks)
                    benchmark = runner.benchmarks{j};
                    message = message + "results of benchmark " + benchmark.id + SystemUtil.lineSep();
                    message = message + jsonencode(runner.results{j}) + SystemUtil.lineSep();
                end
            catch error
                logger.error("error while running benchmarks, restoring project state");
                try
                    snapshotManager.restoreProjectState();
                    logger.info("successfully restored project state");
                catch restoreError
                    logger.error("failed to restore state. try checking out previous branch and");
                    logger.error("    running restore-state command. If this fails, consult the instructions.");
                    logger.error("    restoring state failed because of:");
                    logger.error(restoreError.getReport());
                end
                rethrow(error);
            end
            snapshotManager.restoreProjectState();
        end
    end
end