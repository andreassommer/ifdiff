classdef (Abstract) UserCommand
    %UserCommand a subcommand for invoking different functions of speedtracker
    % Each of the commands that a user can pass to the top-level speedtracker() function to run
    % different functions of the program is implemented as a UserCommand. Bundles argument handling, help
    % messages, and execution in one class.

    properties (Constant)
        ERROR_BAD_ARGUMENT = 'UserCommand:badArgument';
        % An exception that is "expected" and, accordingly, should be handled and/or logged in a legible way.
        % Concretely, an exception with this identifier should have a user-friendly message that the main script
        % will simply print out. All other exceptions should be debug-logged with stack trace.
        ERROR_EXPECTED_EXCEPTION = 'UserCommand:expectedException';
    end

    methods (Abstract)
        % The name that the command is called by
        % Used by the user to call the command, and then by the main function to select the right UserCommand instance.
        name = getName(this);
        % A single line describing how (with what parameters) to run this command
        % When the user asks for general help, the shortHelp() of all commands is printed out.
        message = shortHelp(this);
        % A full help message that can be used as a complete response when the user asks for help about this command
        message = longHelp(this);
        % Parse the arguments of the main program into a struct compatible with execute()
        % Given the cell array of arguments that the user passed to the main function, return a struct
        % with the parsed parameters that can be passed to execute. If the arguments are invalid,
        % throw an exception with the identifier UserCommand.ERROR_BAD_ARGUMENT and a message that
        % describes succinctly what is wrong.
        % The first argument is always the command name.
        % Rule 1: the output struct must be syntactically compatible with execute(), that is there are no
        %   required properties missing and they all have a usable data type. Semantic errors should
        %   instead be handled by execute()
        commandConfig = handleArgs(this, argCell);
        % Run the command using the struct that was produced by handleArgs.
        % Return an arbitrary result of the command which will be returned
        % to the user as the result of the top-level speedtracker function.
        % Rule 1: must be syntactically compatible with the output of handleArgs(), that is, it must not
        %   fail because of missing properties or bad data types of properties.
        % Rule 2: expected exceptions must be handled (including cleanup), and the method must then
        %   throw an exception with the identifier UserCommand.ERROR_EXPECTED_EXCEPTION and a human-readable description
        %   of what went wrong. "Expected"
        %   means that it can be deduced from the specification document, e.g. if the user tries to run
        %   a benchmark with a valid name, but which does not exist. Exceptions due to a bug in the
        %   code or due to unforeseeable circumstances can be thrown as-is and will be logged fully for debug purposes.
        message = execute(this, logger, commandConfig);
    end

    methods (Static)
        % Given a vector cell array of UserCommand objects and a string commandName, return the command whose
        % name matches commandName, or the empty array if none is found.
        function command = getCommand(commands, commandName)
            command = [];
            for i = 1:length(commands)
                if (strcmp(commandName, commands{i}.getName()))
                    command = commands{i};
                end
            end
        end
    end
end