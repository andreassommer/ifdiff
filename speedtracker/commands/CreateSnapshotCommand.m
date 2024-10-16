classdef CreateSnapshotCommand < UserCommand
    methods
        function this = CreateSnapshotCommand()
        end

        function name = getName(~)
            name = 'create-snapshot';
        end

        function msg = shortHelp(this)
            msg = sprintf('speedtracker(''%s'', <id>, [<hash>])', this.getName());
        end

        function msg = longHelp(this)
            msg = strjoin({ ...
                sprintf('speedtracker(''%s'', <id>, [<hash>])', this.getName()), ...
                '    Create a new snapshot with the name <id> from the Git commit indicated by <hash>.', ...
                '    If no hash is specified, the commit pointed to by HEAD is used.' ...
            }, SystemUtil.lineSep());
        end

        function commandConfig = handleArgs(~, argCell)
            % Process arguments, producing a struct that can be passed to execute()
            % Form of the result struct:
            % {
            %   ID: simpleString,
            %   [Commit: simpleString]
            % }
            % where simpleString means either a 1x1 string array or a 1xN character array.
            commandConfig = struct();
            if (length(argCell) <= 1)
                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, 'no ID for new snapshot provided'));
            end
            snapshotID = argCell{2};
            if ~StringUtil.isSimpleString(snapshotID)
                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, sprintf( ...
                    'expected a string or a char vector for snapshot ID, but got %s', StringUtil.toStr(snapshotID))));
            end
            commandConfig.ID = snapshotID;
            if (length(argCell) > 2)
                commit = argCell{3};
                if ~StringUtil.isSimpleString(commit)
                    throw(MException(UserCommand.ERROR_BAD_ARGUMENT, sprintf( ...
                        'expected a string or a char vector for commit SHA, but got %s', StringUtil.toStr(commit))));
                end
                commandConfig.Commit = commit;
            end
        end

        function message = execute(~, logger, commandConfig)
            snapshotManager =  GitSnapshotManager(logger);
            snapshotID = commandConfig.ID;
            try
                if isfield(commandConfig, 'Commit')
                    [id, commit] = snapshotManager.createSnapshot(snapshotID, commandConfig.Commit);
                else
                    [id, commit] = snapshotManager.createSnapshot(snapshotID);
                end
            catch error
                switch error.identifier
                    case {  SnapshotLoader.ERROR_BAD_SNAPSHOT_ID, ...
                            GitSnapshotManager.ERROR_NAME_TAKEN, ...
                            GitSnapshotManager.ERROR_BAD_COMMIT }
                        throw(MException(UserCommand.ERROR_EXPECTED_EXCEPTION, error.message));
                    otherwise
                        rethrow(error);
                end
            end
            message = sprintf('created snapshot with ID %s from commit %s', id, commit);
        end
    end
end