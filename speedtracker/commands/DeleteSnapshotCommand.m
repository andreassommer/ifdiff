classdef DeleteSnapshotCommand < UserCommand
    methods
        function this = DeleteSnapshotCommand()
        end

        function name = getName(~)
            name = "delete-snapshot";
        end

        function msg = shortHelp(this)
            msg = sprintf("speedtracker(""%s"", <id>)", this.getName());
        end

        function msg = longHelp(this)
            msg = strjoin([ ...
                sprintf("speedtracker(""%s"", <id>)", this.getName()), ...
                "    Delete the snapshot indicated by the name <id>, if it exists." ...
            ], SystemUtil.lineSep());
        end

        % Process arguments, producing a struct of the form:
        % {
        %   ID: simpleString
        % }
        % where simpleString means either a 1x1 string array or a 1xN character array.
        function commandConfig = handleArgs(~, argCell)
            commandConfig = struct();
            if (length(argCell) <= 1)
                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, "no snapshot ID provided"));
            end
            snapshotID = argCell{2};
            if ~StringUtil.isSimpleString(snapshotID)
                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, ...
                    "expected a string or a char vector for snapshot ID, but got " + StringUtil.toStr(snapshotID)));
            end
            commandConfig.ID = snapshotID;
        end

        function message = execute(~, logger, commandConfig)
            snapshotManager =  GitSnapshotManager(logger);
            snapshotID = commandConfig.ID;
            try
                [id, sha] = snapshotManager.deleteSnapshot(snapshotID);
            catch error
                switch error.identifier
                    case SnapshotLoader.ERROR_BAD_SNAPSHOT_ID
                        throw(MException(UserCommand.ERROR_EXPECTED_EXCEPTION, error.message));
                    otherwise
                        rethrow(error)
                end
            end
            message = sprintf("deleted snapshot %s (was %s)", id, sha);
        end
    end
end