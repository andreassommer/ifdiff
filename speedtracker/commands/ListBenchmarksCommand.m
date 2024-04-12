classdef ListBenchmarksCommand < UserCommand
    methods
        function this = ListBenchmarksCommand()
        end

        function name = getName(~)
            name = 'list-benchmarks';
        end

        function msg = shortHelp(this)
            msg = sprintf('speedtracker(''%s'')', this.getName());
        end

        function msg = longHelp(this)
            msg = strjoin({ ...
                sprintf('speedtracker(''%s'')', this.getName()), ...
                '    List available benchmarks' ...
            }, SystemUtil.lineSep());
        end

        function commandConfig = handleArgs(~, ~)
            % Process arguments, producing a struct that can be passed to execute()
            % Form of the result struct:
            % { <empty> }
            commandConfig = struct();
        end

        function message = execute(~, logger, ~)
            benchmarkRunner = FunctionBenchmarkRunner(logger, @compareIfdiffSols);
            benchmarks = benchmarkRunner.listBenchmarks();
            if isempty(benchmarks)
                message = '';
            else
                message = strjoin(benchmarks, SystemUtil.lineSep());
            end
        end
    end
end

