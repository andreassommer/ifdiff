classdef RunBenchmarksCommand < UserCommand
    methods
        function this = RunBenchmarksCommand()
        end

        function name = getName(~)
            name = "run";
        end

        function msg = shortHelp(this)
            msg = sprintf("speedtracker(""%s"", <varargin>)", this.getName());
        end

        function msg = longHelp(this)
            msg = strjoin([v
                sprintf("speedtracker(""%s"", <varargin>)", this.getName()), ...
                "    Run benchmarks across various snapshots and collect the results.", ...
                "    speedtracker does this by successively checking out each snapshot,", ...
                "    running every supplied benchmark in the context of that snapshot,", ...
                "    collecting the results in a format TBD, ", ...
                "    and finally restoring the state of the repository before the command was invoked.", ...
                "    ", ...
                "    <varargin> is a list of key-value pairs, e.g. ", ...
                sprintf("    speedtracker(""%s"", 'SnapshotFile', 'snapshots.txt')", this.getName()), ...
                "    If something goes wrong and the state is not restored, you may try the", ...
                "    restore-state command to restore it.", ...
                "    the available vararg parameters are :", ...
                "    Snapshots: a 1xN string array of snapshot IDs to test in the order specified.", ...
                "      Default is all snapshots in the order their commits were created.", ...
                "    Benchmarks: a 1xN string array of benchmark IDs to run. By default, all benchmarks are", ...
                "      run in an unspecified order.", ...
                "    OutputType: (NTables | OneTable | Raw) how to print the output: As one struct for each", ...
                "      benchmark (Raw), one table for each benchmark(NTables), or one table for all benchmarks" ...
                "      (OneTable, default) ", ...
                "    XEndTol: a 1x1 double describing the relative tolerance for deciding whether the final x", ...
                "      values of two different snapshots' benchmark runs are considered the same.", ...
                "    " ...
            ], SystemUtil.lineSep());
        end

        % Process arguments, producing a struct of the form:
        % {
        %   [Snapshots: 1xN string]      % only one of Snapshots and SnapshotFile can be present
        %   [SnapshotFile: simpleString]
        %   [Benchmarks: 1xN string]
        %   [OutputType: ("NTables" | "OneTable" | "Raw")]
        %   [XEndTol: 1xN double]
        % }
        % where simpleString means either a 1x1 string array or a 1xN character array.
        function commandConfig = handleArgs(~, argCell)
            commandConfig = struct();
            if length(argCell) > 2
                % ignore excess last argument
                if mod(length(argCell), 2) == 1; endIx = length(argCell)-1; else; endIx = length(argCell)-2; end
                for i=2:2:endIx
                    key = argCell{i};
                    value = argCell{i+1};
                    switch(lower(key))
                        case "snapshots"
                            if ~isstring(value)
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, ...
                                        "parameter Snapshots expects a string vector, but got type " + class(value)));
                            end
                            if length(size(value)) ~= 2 || (size(value, 1) ~= 1)
                                dimStr = strjoin(string(size(value)), " x ");
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, ...
                                        "parameter Snapshots expects a 1xN string vector, but got dimensions " + dimStr));
                            end
                            commandConfig.Snapshots = value;
                        case "benchmarks"
                            if ~isstring(value)
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, ...
                                        "parameter Benchmarks expects a string vector, but got type " + class(value)));
                            end
                            if length(size(value)) ~= 2 || (size(value, 1) ~= 1)
                                dimStr = strjoin(string(size(value)), " x ");
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, ...
                                        "parameter Benchmarks expects a 1xN string vector, but got dimensions " + dimStr));
                            end
                            commandConfig.Benchmarks = value;
                        case "outputtype"
                            % This property overrides a property in UserConfig, that's why UserConfig also has a
                            % method for checking if the value is acceptable.
                            if ~UserConfig.checkOutputType(value)
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, ...
                                    UserConfig.describeBadOutputType(value)));
                            end
                            commandConfig.OutputType = value;
                        case "xendtol"
                            if ~IfdiffBenchmarkConfig.checkXEndTol(value)
                                throw(MException(UserCommand.ERROR_BAD_ARGUMENT, IfdiffBenchmarkConfig.describeBadXEndTol(value)));
                            end
                            commandConfig.XEndTol = value;
                        otherwise
                    end
                end
            end
        end

        function result = execute(this, logger, commandConfig)
            IfdiffBenchmarkRunner.setConfig(IfdiffBenchmarkConfig());
            this.saveGlobalParameters(commandConfig);

            snapshotManager = GitSnapshotManager(logger);
            benchmarkRunner = IfdiffBenchmarkRunner(logger);
            speedtracker = Speedtracker(logger, snapshotManager, benchmarkRunner);

            speedtracker = speedtracker.run(commandConfig);
            result = speedtracker.getBenchmarkResults();
        end
    end


    methods (Access=private)
        % Store all the user parameters that overwrite global config parameters in the global UserConfig
        function saveGlobalParameters(~, commandConfig)
            userConfig = ConfigProvider.getUserConfig();
            benchmarkConfig = IfdiffBenchmarkRunner.getConfig();

            if isfield(commandConfig, "OutputType")
                userConfig.OutputType = commandConfig.OutputType;
            end
            if isfield(commandConfig, "XEndTol")
                benchmarkConfig.XEndTol = commandConfig.XEndTol;
            end
    
            ConfigProvider.setUserConfig(userConfig);
            IfdiffBenchmarkRunner.setConfig(benchmarkConfig);
        end

    end
end