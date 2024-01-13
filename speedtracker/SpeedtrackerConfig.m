classdef SpeedtrackerConfig
    %SpeedtrackerConfig Holder for program-global configuration parameters for Speedtracker

    properties (Access=public)
        % Base directory of the project
        baseDir;
        % Base directory of Speedtracker
        speedtrackerDir;
        % Before any business code runs, all source code for Speedtracker is copied to a temp dir, so that loading
        % snapshots cannot overwrite Speedtracker-internal code and cause mayhem.
        tempDir;
        % Available user commands
        userCommands;
    end

    methods
        function obj = SpeedtrackerConfig()
        end
    end
end