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
        % return the output of `system(sprintf(varargin{:}))`. If the output has trailing newlines, these are removed.
        % If there are any newlines in the input, throw an exception.
        % Apparently, git commands' output uses LF instead of CRLF as line terminators, so good thing we have all
        % of those cases enumerated!
        function [status, cmdout] = safeSystem(commandStr)
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
    
        % return the output of `system(sprintf(varargin{:}))`. If the output has trailing newlines, these are removed.
        % If there are any newlines in the input, proceed anyway.
        % Apparently, git commands' output uses LF instead of CRLF as line terminators, so good thing we have all
        % of those cases enumerated! Beware.
        function [status, cmdout] = unsafeSystem(commandStr)
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

        % Line ending for output.
        % It seems MATLAB's policy about line endings is to only use \n internally, and convert when on Windows
        % (see https://de.mathworks.com/help/matlab/ref/fopen.html#btrnibn-1-permission)
        % which would imply just using the `newline` command everywhere and not bothering with a wrapper function.
        % However, e.g. the system command does not mention doing this (even though it does), so it could be
        % good to keep this safeguard.
        function str = lineSep()
            % if ispc()
            %     str = sprintf("\r\n");
            % elseif ismac()
            %     str = sprintf("\r");
            % else
            %     str = string(newline);
            % end
            str = string(newline);
        end

        % Line separator used in Git output. Useful for checking e.g. if a `git tag -l` output contains multiple tags
        % It seems MATLAB's policy about line endings is to only use \n internally, and convert when on Windows
        % (see https://de.mathworks.com/help/matlab/ref/fopen.html#btrnibn-1-permission)
        % which would imply just using the `newline` command everywhere and not bothering with a wrapper function.
        % However, e.g. the system command does not mention doing this (even though it does), so it could be
        % good to keep this safeguard.

        function str = gitOutputLineSep()
            str = string(newline);
        end
    end
end