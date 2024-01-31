classdef ListSnapshotsCommand < UserCommand
    methods
        function this = ListSnapshotsCommand()
        end

        function name = getName(~)
            name = "list-snapshots";
        end

        function msg = shortHelp(this)
            msg = sprintf("speedtracker(""%s"")", this.getName());
        end

        function msg = longHelp(this)
            msg = strjoin([
                sprintf("speedtracker(""%s"")", this.getName()), ...
                "    List all available snapshots"
            ], SystemUtil.lineSep());
        end

        % Process arguments, producing a struct of the form
        % { }
        function commandConfig = handleArgs(~, ~)
            commandConfig = struct();
        end

        function message = execute(~, logger, ~)
            speedtrackerConfig = ConfigProvider.getSpeedtrackerConfig();
            snapshotManager = GitSnapshotManager(speedtrackerConfig, logger);
            snapshots = snapshotManager.listSnapshots();
            if isempty(snapshots)
                message = "";
            else
                message = strjoin(snapshots, SystemUtil.lineSep());
            end
        end
    end
end