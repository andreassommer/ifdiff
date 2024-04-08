classdef RunBenchmarksCommand < UserCommand
    methods
        function this = RunBenchmarksCommand()
        end

        function name = getName(~)
            name = 'run';
        end

        function msg = shortHelp(this)
            msg = sprintf('speedtracker(''%s'', <varargin>)', this.getName());
        end

        function msg = longHelp(this)
            msg = strjoin({
                sprintf('speedtracker(''%s'', <varargin>)', this.getName()), ...
                '    Run benchmarks across various snapshots and collect the results.', ...
                '    speedtracker does this by successively checking out each snapshot,', ...
                '    running every supplied benchmark in the context of that snapshot,', ...
                '    collecting the results in a format TBD, ', ...
                '    and finally restoring the state of the repository before the command was invoked.', ...
                '    ', ...
                '    <varargin> is a list of key-value pairs, e.g. ', ...
                sprintf('    speedtracker(''%s'', ''SnapshotFile'', ''snapshots.txt'')', this.getName()), ...
                '    If something goes wrong and the state is not restored, you may try the', ...
                '    restore-state command to restore it.', ...
                '    the available vararg parameters are :', ...
                '    Snapshots: a cellstring/string array of snapshot IDs and commit SHAs to test in the', ...
                '      order specified. Default is all snapshots in the order their commits were created.', ...
                '    Benchmarks: a cellstring/string array of benchmark IDs to run. By default, all benchmarks are', ...
                '      run in an unspecified order.', ...
                '    OutputType: (OneTable | Raw) how to print the output: As one struct for each', ...
                '      benchmark (Raw) or one table for all benchmarks' ...
                '      (OneTable, default) ', ...
                '    YEndTol: a 1x1 double describing the relative tolerance for deciding whether the final y', ...
                '      values of two different snapshots'' benchmark runs are considered the same.', ...
                '    ' ...
            }, SystemUtil.lineSep());
        end

        function commandConfig = handleArgs(~, argCell)
            % Process arguments, producing a struct that can be passed to execute()
            % Form of the result struct:
            % {
            %   [Snapshots: 1xN string]
            %   [Benchmarks: 1xN string]
            %   [OutputType: ('OneTable' | 'Raw')]
            %   [YEndTol: 1xN double]
            % }
            % where simpleString means either a 1x1 string array or a 1xN character array.
            commandConfig = struct();
            if length(argCell) > 2
                % ignore excess last argument
                if mod(length(argCell), 2) == 1; endIx = length(argCell)-1; else; endIx = length(argCell)-2; end
                for i=2:2:endIx
                    key = argCell{i};
                    value = argCell{i+1};
                    switch(lower(key))
                        case 'snapshots'
                            if ~StringUtil.isStringArray(value)
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, sprintf( ...
                                        'Snapshots: %s', StringUtil.describeBadStringArray(value))));
                            end
                            if isstring(value)
                                value = cellstr(value);
                            end
                            commandConfig.Snapshots = value;
                        case 'benchmarks'
                            if ~StringUtil.isStringArray(value)
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, sprintf( ...
                                        'Benchmarks: %s', StringUtil.describeBadStringArray(value))));
                            end
                            if isstring(value)
                                value = cellstr(value);
                            end
                            commandConfig.Benchmarks = value;
                        case 'outputtype'
                            % This property overrides a property in UserConfig, that's why UserConfig also has a
                            % method for checking if the value is acceptable.
                            if ~UserConfig.checkOutputType(value)
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, sprintf( ...
                                    'OutputType: %s', UserConfig.describeBadOutputType(value))));
                            end
                            commandConfig.OutputType = value;
                        case 'yendtol'
                            if ~UserConfig.checkYEndTol(value)
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, sprintf( ...
                                    'YEndTol: %s', UserConfig.describeBadYEndTol(value))));
                            end
                            commandConfig.YEndTol = value;
                        otherwise
                    end
                end
            end
        end

        function result = execute(this, logger, commandConfig)
            this.saveGlobalParameters(commandConfig);

            snapshotManager = GitSnapshotManager(logger);
            benchmarkRunner = SimpleBenchmarkRunner(logger, @compareIfdiffSols);
            speedtrackerRunner = SpeedtrackerRunner(logger, snapshotManager, benchmarkRunner);

            % Determine snapshots and benchmarks to run
            if isfield(commandConfig, 'Snapshots')
                snapshots = commandConfig.Snapshots;
                % Check the snapshots
                allSnapshots = snapshotManager.listSnapshots();
                for i = 1:length(snapshots)
                    if ~ismember(snapshots{i}, allSnapshots) && ~snapshotManager.isCommitSha(snapshots{i})
                        throw(MException(UserCommand.ERROR_EXPECTED_EXCEPTION, sprintf( ...
                            'no such snapshot or commit: %s', snapshots{i})));
                    end
                end
            else
                snapshots = snapshotManager.listSnapshots();
            end
            if isfield(commandConfig, 'Benchmarks')
                benchmarks = commandConfig.Benchmarks;
            else
                benchmarks = benchmarkRunner.listBenchmarks();
            end

            % Main: run the benchmarks and return the results
            initPaths();
            try
                speedtrackerRunner = speedtrackerRunner.run(snapshots, benchmarks);
            catch error
                throw(this.wrapSpeedtrackerError(error));
            end
            result = speedtrackerRunner.getBenchmarkResults();
        end
    end


    methods (Access=private)
        % Store all the user parameters that overwrite global config parameters in the global UserConfig
        function saveGlobalParameters(~, commandConfig)
            userConfig = ConfigProvider.getUserConfig();

            if isfield(commandConfig, 'OutputType')
                userConfig.OutputType = commandConfig.OutputType;
            end
            if isfield(commandConfig, 'YEndTol')
                userConfig.YEndTol = commandConfig.YEndTol;
            end
    
            ConfigProvider.setUserConfig(userConfig);
        end

        function newError = wrapSpeedtrackerError(~, error)
            % Set an exception's identifier to UserCommand.ERROR_EXPECTED_EXCEPTION if it is one of the expected exceptions
            % The expected exceptions, as per the instructions, are:
            % E1: There are staged changes in Git
            % E2: The Git repository is in detached HEAD mode
            % E3: The project state cannot be saved because there is already a saved state present
            % E4: One or more of the requested benchmarks are not found or faulty
            switch error.identifier
                case BenchmarkRunner.ERROR_BAD_BENCHMARK
                    newError = MException( ...
                        UserCommand.ERROR_EXPECTED_EXCEPTION, ...
                        sprintf('could not initialize a benchmark: %s', error.message));
                case SnapshotLoader.ERROR_BAD_SNAPSHOT_ID
                    newError = MException( ...
                        UserCommand.ERROR_EXPECTED_EXCEPTION, ...
                        sprintf('could not load a snapshot: %s', error.message));
                case SnapshotLoader.ERROR_SAVED_STATE_PRESENT
                    newError = MException( ...
                        UserCommand.ERROR_EXPECTED_EXCEPTION, [ ...
                            'cannot save project state as a saved state is already present' SystemUtil.lineSep() ...
                            'you may try the restore-state command to restore the project and consume the saved state.']);
                case SnapshotLoader.ERROR_COULD_NOT_SAVE_STATE
                    if isempty(error.cause)
                        newError = error;
                        return;
                    end
                    innerError = error.cause{1};
                    if ismember(innerError.identifier, ...
                            [GitSnapshotManager.ERROR_DETACHED_HEAD GitSnapshotManager.ERROR_STAGED_CHANGES_PRESENT])
                        newError = MException(UserCommand.ERROR_EXPECTED_EXCEPTION, innerError.message);
                    else
                        newError = error;
                    end
                otherwise
                    rethrow(error);
            end
        end
    end
end