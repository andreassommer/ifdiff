classdef ShowSnapshotCommand < UserCommand
    methods
        function this = ShowSnapshotCommand()
        end

        function name = getName(~)
            name = "show-snapshot";
        end

        function msg = shortHelp(this)
            msg = sprintf("speedtracker(""%s"", <id>)", this.getName());
        end

        function msg = longHelp(this)
            msg = strjoin([ ...
                sprintf("speedtracker(""%s"", <id>)", this.getName()), ...
                "    Describe the snapshot indicated by the name <id>, if it exists." ...
            ], SystemUtil.lineSep());
        end

        function commandConfig = handleArgs(~, argCell)
            % Process arguments, producing a struct that can be passed to execute()
            % Form of the result struct:
            % {
            %   ID: simpleString
            % }
            % where simpleString means either a 1x1 string array or a 1xN character array.
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
            snapshotID = commandConfig.ID;
            snapshotManager =  GitSnapshotManager(logger);
            try
                infoDict = snapshotManager.getSnapshotInfo(snapshotID);
            catch error
                switch(error.identifier)
                    case SnapshotLoader.ERROR_BAD_SNAPSHOT_ID
                        throw(MException(UserCommand.ERROR_EXPECTED_EXCEPTION, error.message));
                    otherwise
                        rethrow(error);
                end
            end
            messageLines = [ ...
                "Snapshot ID: " + snapshotID, ...
                "Commit SHA:  " + infoDict("commitSha"), ...
                "Author:      " + infoDict("author"), ...
                "Date:        " + string(datetime(str2double(infoDict("authorDate")), "ConvertFrom", "posixtime", ...
                    "Format", "yyyy-MM-dd HH:mm:ssZ", "TimeZone", infoDict("authorTimeZone"))), ...
                " ", ...
                infoDict("subject"), ...
            ];
            message = strjoin(messageLines, SystemUtil.lineSep());
        end
    end
end