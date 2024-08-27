classdef ShowSnapshotCommand < UserCommand
    methods
        function this = ShowSnapshotCommand()
        end

        function name = getName(~)
            name = 'show-snapshot';
        end

        function msg = shortHelp(this)
            msg = sprintf('speedtracker(''%s'', <id>)', this.getName());
        end

        function msg = longHelp(this)
            msg = strjoin({ ...
                sprintf('speedtracker(''%s'', <id>)', this.getName()), ...
                '    Describe the snapshot indicated by the name <id>, if it exists.' ...
            }, SystemUtil.lineSep());
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
                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, 'no snapshot ID provided'));
            end
            snapshotID = argCell{2};
            if ~StringUtil.isSimpleString(snapshotID)
                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, sprintf( ...
                    'expected a string or a char vector for snapshot ID, but got %s', StringUtil.toStr(snapshotID))));
            end
            commandConfig.ID = snapshotID;
        end

        function message = execute(~, logger, commandConfig)
            snapshotID = commandConfig.ID;
            snapshotManager =  GitSnapshotManager(logger);
            try
                snapshotInfo = snapshotManager.getSnapshotInfo(snapshotID);
            catch error
                switch(error.identifier)
                    case SnapshotLoader.ERROR_BAD_SNAPSHOT_ID
                        throw(MException(UserCommand.ERROR_EXPECTED_EXCEPTION, error.message));
                    otherwise
                        rethrow(error);
                end
            end
            messageLines = { ...
                sprintf('Snapshot ID: %s', snapshotID), ...
                sprintf('Commit SHA:  %s', olGetOption(snapshotInfo, 'CommitSha')), ...
                sprintf('Author:      %s', olGetOption(snapshotInfo, 'Author')), ...
                sprintf('Date:        %s', char(datetime(str2double(olGetOption(snapshotInfo, 'AuthorDate')), ...
                    'ConvertFrom', 'posixtime', ...
                    'Format', 'yyyy-MM-dd HH:mm:ssZ', ...
                    'TimeZone', olGetOption(snapshotInfo, 'AuthorTimeZone')))), ...
                ' ', ...
                sprintf('%s', olGetOption(snapshotInfo, 'Subject')), ...
            };
            message = strjoin(messageLines, SystemUtil.lineSep());
        end
    end
end