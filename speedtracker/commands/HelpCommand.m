classdef HelpCommand < UserCommand
    methods
        function this = HelpCommand()
        end

        function name = getName(~)
            name = "help";
        end

        function msg = shortHelp(this)
            msg = sprintf("speedtracker(""%s"", [<command>])", this.getName());
        end

        function msg = longHelp(this)
            msg = strjoin([ ...
                sprintf("speedtracker(""%s"", [<command>])", this.getName()), ...
                "    describe a command's function and usage, or show general help if <command> is not provided" ...
            ], SystemUtil.lineSep());
        end

        function commandConfig = handleArgs(~, argCell)
            % Process arguments, producing a struct that can be passed to execute()
            % Form of the result struct:
            % {
            %   [About: command]    % simpleString that is one of the available commands.
            % }
            % where simpleString means either a 1x1 string array or a 1xN character array.
            commandConfig = struct();
            if (length(argCell) > 1)
                if ~StringUtil.isSimpleString(argCell{2})
                    throw(MException(UserCommand.ERROR_BAD_ARGUMENT, ...
                        "expected the name of a command, but got [" + StringUtil.toStr(argCell{2}) + "]"));
                end
                commandConfig.About = argCell{2};
            end
        end

        function message = execute(this, ~, commandConfig)
            speedtrackerConfig = ConfigProvider.getSpeedtrackerConfig();
            if (isfield(commandConfig, "About"))
                command = UserCommand.getCommand(speedtrackerConfig.userCommands, commandConfig.About);
                if isempty(command)
                    throw(MException(UserCommand.ERROR_EXPECTED_EXCEPTION, "unknown command: " + commandConfig.About));
                end
                message = command.longHelp();
            else
                message = generalHelp(this);
            end
        end

        function message = generalHelp(this)
            % Create a general help message listing the commands and describing how to get more info about each.
            speedtrackerConfig = ConfigProvider.getSpeedtrackerConfig();
            commands = speedtrackerConfig.userCommands;
            messageLines = ["Usage:", " "];
            for i = 1:length(commands)
                messageLines = [messageLines, commands{i}.shortHelp()];
            end
            messageLines = [messageLines, " ", ...
                sprintf("run speedtracker(""%s"", <command>) for more info about individual commands", this.getName())];
            message = strjoin(messageLines, SystemUtil.lineSep());
        end
    end
end