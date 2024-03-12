classdef SystemUtil

    methods (Static)
        function getLogger = setGetLogger(setLogger)
            persistent logger;
            if (nargin == 0 && isempty(logger))
                logger = Logger();
            elseif (nargin == 0)
                getLogger = logger;
            else
                logger = setLogger;
                getLogger = setLogger;
            end
        end

        function [status, cmdout] = safeSystem(commandStr)
            % Run a system command, removing trailing newlines. Throw if the input contains newlines.
            logger = SystemUtil.setGetLogger();
            if (contains(commandStr, sprintf("\r")) || contains(commandStr, newline))
                throw(MException(SystemUtil.ERROR_ILLEGAL_ARGUMENT, "command contains line breaks: " + commandStr));
            end
            logger.debug("`" + commandStr + "`");
            [status, cmdout] = system(commandStr);
            if endsWith(cmdout, sprintf("\r\n"))
                cmdout = extractBefore(cmdout, strlength(cmdout) - 1);
            elseif endsWith(cmdout, newline)
                cmdout = extractBefore(cmdout, strlength(cmdout));
            elseif endsWith(cmdout, sprintf("\r"))
                cmdout = extractBefore(cmdout, strlength(cmdout));
            end
            cmdout = string(cmdout);
            logger.debug("command output:");
            outputLines = splitlines(cmdout);
            for i=1:length(outputLines)
                logger.debug("    "  + outputLines(i));
            end
        end
    
        function [status, cmdout] = unsafeSystem(commandStr)
            % Run a system command, removing trailing newlines. If there are any newlines in the input, proceed anyway.
            logger = SystemUtil.setGetLogger();
            logger.debug("`" + commandStr + "`");
            [status, cmdout] = system(commandStr);
            if endsWith(cmdout, sprintf("\r\n"))
                cmdout = extractBefore(cmdout, strlength(cmdout) - 1);
            elseif endsWith(cmdout, newline)
                cmdout = extractBefore(cmdout, strlength(cmdout));
            elseif endsWith(cmdout, sprintf("\r"))
                cmdout = extractBefore(cmdout, strlength(cmdout));
            end
            cmdout = string(cmdout);
            logger.debug("command output:");
            outputLines = splitlines(cmdout);
            for i=1:length(outputLines)
                logger.debug("    "  + outputLines(i));
            end
        end

        function str = lineSep()
            % Line ending for output.
            % It seems MATLAB's policy about line endings is to only use \n internally, and convert when on Windows
            % (see https://de.mathworks.com/help/matlab/ref/fopen.html#btrnibn-1-permission)
            % which would imply just using the `newline` command everywhere and not bothering with a wrapper function.
            % However, e.g. the system command does not mention doing this (even though it does), so it could be
            % good to keep this safeguard.

            % if ispc()
            %     str = sprintf("\r\n");
            % elseif ismac()
            %     str = sprintf("\r");
            % else
            %     str = string(newline);
            % end
            str = string(newline);
        end

        function str = gitOutputLineSep()
            % Line separator used in Git output.
            % Useful for checking e.g. if a `git tag -l` output contains multiple tags
            % It seems MATLAB's policy about line endings is to only use \n internally, and convert when on Windows
            % (see https://de.mathworks.com/help/matlab/ref/fopen.html#btrnibn-1-permission)
            % which would imply just using the `newline` command everywhere and not bothering with a wrapper function.
            % However, e.g. the system command does not mention doing this (even though it does), so it could be
            % good to keep this safeguard.
            str = string(newline);
        end
    end
end