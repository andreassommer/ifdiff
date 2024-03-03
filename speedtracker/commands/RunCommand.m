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
                "    If something goes wrong and the state is not restored, you may try the", ...
                "    restore-state command to restore it.", ...
                "    the available vararg parameters are :", ...
                "    Snapshots: a 1xN string array of snapshot IDs to test in the order specified.", ...
                "      Default is all snapshots in the order their commits were created.", ...
                "    Benchmarks: a 1xN string array of benchmark IDs to run. By default, all benchmarks are", ...
                "      run in an unspecified order.", ...
                "    OutputType: (NTables | OneTable | Raw) how to print the output: As one struct for each", ...
                "      benchmark (Raw), one table for each benchmark(NTables), or one table for all benchmarks" ...
                "      (OneTable, default) ", ...
                "    XEndTol: a 1x1 double describing the relative tolerance for deciding whether the final x", ...
                "      values of two different snapshots' benchmark runs are considered the same.", ...
                "    "
            ], SystemUtil.lineSep());
        end

        % Process arguments, producing a struct of the form:
        % {
        %   [Snapshots: 1xN string]      % only one of Snapshots and SnapshotFile can be present
        %   [SnapshotFile: simpleString]
        %   [Benchmarks: 1xN string]
        %   [OutputType: ("NTables" | "OneTable" | "Raw")]
        %   [XEndTol: 1xN double]
        % }
        % where simpleString means either a 1x1 string array or a 1xN character array.
        function commandConfig = handleArgs(~, argCell)
            commandConfig = struct();
            if length(argCell) > 2
                % ignore excess last argument
                if mod(length(argCell), 2) == 1; endIx = length(argCell)-1; else; endIx = length(argCell)-2; end
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
                            if ~isstring(value)
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, ...
                                        "parameter Benchmarks expects a string vector, but got type " + class(value)));
                            end
                            if length(size(value)) ~= 2 || (size(value, 1) ~= 1)
                                dimStr = strjoin(string(size(value)), " x ");
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, ...
                                        "parameter Benchmarks expects a 1xN string vector, but got dimensions " + dimStr));
                            end
                            commandConfig.Benchmarks = value;
                        case "OutputType"
                            % This property overrides a property in UserConfig, that's why UserConfig also has a
                            % method for checking if the value is acceptable.
                            if ~UserConfig.checkOutputType(value)
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, ...
                                    UserConfig.describeBadOutputType(value)));
                            end
                            commandConfig.OutputType = value;
                        case "XEndTol"
                            if ~UserConfig.checkXEndTol(value)
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, UserConfig.describeBadXEndTol(value)));
                            end
                            commandConfig.XEndTol = value;
                        otherwise
                    end
                end
            end
        end

        function result = execute(this, logger, commandConfig)
            this.saveGlobalParameters(commandConfig);
            snapshotManager = GitSnapshotManager(logger);
            benchmarkRunner = IfdiffBenchmarkRunner(logger);

            if isfield(commandConfig, "Snapshots")
                snapshots = commandConfig.Snapshots;
            else
                snapshots = snapshotManager.listSnapshots();
            end
            if isfield(commandConfig, "Benchmarks")
                benchmarks = commandConfig.Benchmarks;
            else
                benchmarks = benchmarkRunner.listBenchmarks();
            end

            try
                benchmarkRunner = benchmarkRunner.init(benchmarks);
            catch initError
                switch initError.identifier
                    case BenchmarkRunner.ERROR_BAD_BENCHMARK
                        throw(MException(UserCommand.ERROR_EXPECTED_EXCEPTION, initError.message));
                    otherwise
                        rethrow(initError);
                end
            end

            try
                snapshotManager = snapshotManager.saveProjectState();
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
                logger.info("running benchmarks " + strjoin(benchmarks, ", "));
                logger.info("  on snapshots " + strjoin(snapshots, ", "));
                for i=1:length(snapshots)
                    logger.info("loading snapshot " + snapshots(i));
                    snapshotManager = snapshotManager.loadSnapshot(snapshots(i));
                    for j=1:length(benchmarks)
                        benchmarkRunner = benchmarkRunner.runBenchmark(snapshots(i), benchmarks(j));
                    end
                    logger.info("ran all benchmarks");
                end
                result = this.convertBenchmarkResults(benchmarkRunner);
            catch error
                logger.error("error while running benchmarks, restoring project state");
                try
                    snapshotManager = snapshotManager.restoreProjectState();
                    logger.info("successfully restored project state");
                catch restoreError
                    logger.error("failed to restore state. try checking out previous branch and");
                    logger.error("    running restore-state command. If this fails, consult the instructions.");
                    logger.error("    restoring state failed because of:");
                    logger.error(restoreError.getReport());
                end
                rethrow(error);
            end
            snapshotManager = snapshotManager.restoreProjectState();
        end

    end


    methods (Access=private)
        % Store all the user parameters that overwrite global config parameters in the global UserConfig
        function saveGlobalParameters(~, commandConfig)
            userConfig = ConfigProvider.getUserConfig();
            if isfield(commandConfig, "OutputType")
                userConfig.OutputType = commandConfig.OutputType;
            end
            if isfield(commandConfig, "XEndTol")
                userConfig.XEndTol = commandConfig.XEndTol;
            end
            ConfigProvider.setUserConfig(userConfig);
        end

        % Convert a cell array of BenchmarkResult objects depending on the specified value of OutputType:
        % convert each to a table, convert them all into one big table, or just return the BenchmarkResult cell
        % unchanged.
        function prettyResult = convertBenchmarkResults(~, benchmarkRunner)
            results = benchmarkRunner.getResults();
            userConfig = ConfigProvider.getUserConfig();
            outputType = userConfig.OutputType;
            switch outputType
                case "NTables"
                    prettyResult = cellfun(@(benchmarkResult) benchmarkRunner.makeTable(benchmarkResult), ...
                        results, ...
                        'UniformOutput', false);
                case "OneTable"
                    tables = cellfun(@(benchmarkResult) benchmarkRunner.makeTable(benchmarkResult), ...
                        results, ...
                        'UniformOutput', false);
                    prettyResult = vertcat(tables{:});
                otherwise
                    prettyResult = results;
            end
        end
    end
end