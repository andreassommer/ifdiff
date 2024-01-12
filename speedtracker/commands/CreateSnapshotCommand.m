classdef CreateSnapshotCommand < UserCommand
    methods
        function this = CreateSnapshotCommand()
        end

        function name = getName(~)
            name = "create-snapshot";
        end

        function msg = shortHelp(~)
            msg = "speedtracker(""create-snapshot"", <id>, [<hash>])";
        end

        function msg = longHelp(~)
            msg = strjoin([
                "speedtracker(""create-snapshot"", <id>, [<hash>])", ...
                "    Create a new snapshot with the name <id> from the Git commit indicated by <hash>.", ...
                "    If no hash is specified, the commit pointed to by HEAD is used."
            ], SystemUtil.lineSep());
        end

        % Process arguments, producing a struct of the form:
        % {
        %   ID: simpleString,
        %   [Commit: simpleString]
        % }
        % where simpleString means either a 1x1 string array or a 1xN character array.
        function commandConfig = handleArgs(~, argCell)
            commandConfig = struct();
            if (length(argCell) <= 1)
                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, "no ID for new snapshot provided"));
            end
            snapshotID = argCell{2};
            if ~UserCommand.isSimpleString(snapshotID)
                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, ...
                    "expected a string or a char vector for snapshot ID, but got " + UserCommand.toStr(snapshotID)));
            end
            commandConfig.ID = snapshotID;
            if (length(argCell) > 2)
                commit = argCell{3};
                if ~UserCommand.isSimpleString(commit)
                    throw(MException(UserCommand.ERROR_BAD_ARGUMENT, ...
                        "expected a string or a char vector for commit SHA, but got " + UserCommand.toStr(commit)));
                end
                commandConfig.Commit = commit;
            end
        end

        function message = execute(~, speedtrackerConfig, logger, commandConfig)
            snapshotManager = GitSnapshotManager(speedtrackerConfig, logger);
            snapshotID = commandConfig.ID;
            try
                if isfield(commandConfig, "Commit")
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
            message = sprintf("created snapshot with ID %s from commit %s", id, commit);
        end
    end
end