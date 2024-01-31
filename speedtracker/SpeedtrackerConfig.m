classdef SpeedtrackerConfig
    %SpeedtrackerConfig Holder for program-global configuration parameters for Speedtracker
    % Careful with this. Since it is accessible globally through ConfigProvider, changes affect large parts of the
    % code in hard-to-track ways. Be very sure about what you want to do before you
    % add, never mind change, properties in this class.

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