classdef ScrewAroundCommand < UserCommand
    %SCREWAROUNDCOMMAND Dummy command for doing stuff while developing that isn't supposed to be part of the application
    %   For example, if you want to put the repo in an illegal state to test out how it responds if this illegal
    %   state comes about accidentally, it's tricky to just use GitSnapshotManager and BenchmarkRunner without
    %   first initializing the config, temp dir, and a bunch of other stuff. By putting your scratch code in the
    %   execute() method of this dummy UserCommand, you can run it with all of Speedtracker's usual tackle
    %   set up for you. To enable it, modify the speedtracker.m script and add this to the `commands` list.

    methods
        function name = getName(~)
            name = "screw-around";
        end

        function msg = shortHelp(this)
            msg = sprintf("speedtracker(""%s"")", this.getName());
        end

        function msg = longHelp(this)
            msg = strjoin([ ...
                sprintf("speedtracker(""%s"")", this.getName()), ...
                "    Dummy command for messing around while developing." ...
            ], SystemUtil.lineSep());
        end

        function commandConfig = handleArgs(~, ~)
            % Process arguments, producing a struct that can be passed to execute()
            commandConfig = struct();
        end

        function message = execute(~, logger, ~)
            % Create an illegal state: Save the project but do not restore afterward.
            % The run command is now impossible, and you have to use restore-state first.
            snapshotManager =  GitSnapshotManager(logger);
            snapshotManager.saveProjectState();
            message = "saved project state";
        end
    end
end
