classdef SimpleLogger < Logger
    %SimpleLogger Simple logger that writes output to a file. The prefixes for the four log modes can be overridden.

    properties (Access=public)
        debugPrefix = 'DEBUG: ';
        infoPrefix = 'INFO: ';
        warnPrefix = 'WARNING: ';
        errorPrefix = 'ERROR: ';
        level = Logger.LEVEL_INFO;
    end

    properties (Access=private)
        outputFile;
    end

    methods
        function this = SimpleLogger(outputFile)
            % Constructor with one parameter: FD for the output file.
            this.outputFile = outputFile;
        end

        function debug(this, message)
            if (this.level >= Logger.LEVEL_DEBUG)
                fprintf(this.outputFile, '%s%s\n', this.debugPrefix, message);
            end
        end

        function info(this, message)
            if (this.level >= Logger.LEVEL_INFO)
                fprintf(this.outputFile, '%s%s\n', this.infoPrefix, message);
            end
        end

        function warn(this, message)
            if (this.level >= Logger.LEVEL_INFO)
                fprintf(this.outputFile, '%s%s\n', this.warnPrefix, message);
            end
        end

        function error(this, message)
            if (this.level >= Logger.LEVEL_ERROR)
                fprintf(this.outputFile, '%s%s\n', this.errorPrefix, message);
            end
        end
    end
end