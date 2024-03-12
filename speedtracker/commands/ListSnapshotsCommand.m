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
            msg = strjoin([ ...
                sprintf("speedtracker(""%s"")", this.getName()), ...
                "    List all available snapshots" ...
            ], SystemUtil.lineSep());
        end

        function commandConfig = handleArgs(~, ~)
            % Process arguments, producing a struct that can be passed to execute()
            % Form of the result struct:
            % { <empty> }
            commandConfig = struct();
        end

        function message = execute(~, logger, ~)
            snapshotManager =  GitSnapshotManager(logger);
            snapshots = snapshotManager.listSnapshots();
            if isempty(snapshots)
                message = "";
            else
                message = strjoin(snapshots, SystemUtil.lineSep());
            end
        end
    end
end