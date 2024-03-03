classdef RestoreStateCommand < UserCommand
    methods
        function this = RestoreStateCommand()
        end

        % Note: RunCommand has this name hard-coded in it a few times. If you change it, make sure to change it
        % in RunCommand as well.
        function name = getName(~)
            name = "restore-state";
        end

        function msg = shortHelp(this)
            msg = sprintf("speedtracker(""%s"")", this.getName());
        end

        function msg = longHelp(this)
            msg = strjoin([
                sprintf("speedtracker(""%s"")", this.getName()), ...
                "    Restore the state of the repository if something went wrong during the run command.", ...
                "    This should never be necessary in regular use; this command is mostly a utility for development.", ...
            ], SystemUtil.lineSep());
        end

        % Process arguments, producing an empty struct
        function commandConfig = handleArgs(~, ~)
            commandConfig = struct();
        end

        function message = execute(~, logger, ~)
            snapshotLoader =  GitSnapshotManager(logger);
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