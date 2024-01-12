classdef RestoreStateCommand < UserCommand
    methods
        function this = RestoreStateCommand()
        end

        function name = getName(~)
            name = "restore-state";
        end

        function msg = shortHelp(~)
            msg = "speedtracker(""restore-state"")";
        end

        function msg = longHelp(~)
            msg = strjoin([
                "speedtracker(""restore-state"")", ...
                "    Restore the state of the repository if something went wrong during the run command.", ...
                "    This should never be necessary in regular use; this command is mostly a utility for development.", ...
            ], SystemUtil.lineSep());
        end

        % Process arguments, producing an empty struct
        function commandConfig = handleArgs(~, ~)
            commandConfig = struct();
        end

        function message = execute(~, speedtrackerConfig, logger, ~)
            snapshotLoader = GitSnapshotManager(speedtrackerConfig, logger);
            try
                snapshotLoader.restoreProjectState();
            catch error
                switch error.identifier
                    case SnapshotLoader.ERROR_NO_SAVED_STATE
                        throw(MException(UserCommand.ERROR_EXPECTED_EXCEPTION, error.message));
                    otherwise
                        rethrow(error)
                end
            end
            message = "";
        end
    end
end