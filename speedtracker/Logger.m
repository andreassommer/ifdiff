classdef Logger
    % Handler for logging events in the code.
    % This is also intended as a configurable replacement for using disp().
    % There is no distinction between internal logging and program output as of now, except via log levels.
    properties (Constant)
        LEVEL_NONE = 0;
        LEVEL_ERROR = 1;
        LEVEL_WARN = 2;
        LEVEL_INFO = 3;
        LEVEL_DEBUG = 4;
    end

    methods (Access=public)
        function debug(~, message)
            fprintf('%s\n', message);
            disp(' ');
        end

        function info(~, message)
            fprintf('%s\n', message);
            disp(' ');
        end

        function warn(~, message)
            fprintf('%s\n', message);
            disp(' ');
        end

        function error(~, message)
            fprintf('%s\n', message);
            disp(' ');
        end
    end
end