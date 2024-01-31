classdef ConfigProvider
    %ConfigProvider Provider for single instances of global configuration objects
    % Configuration objects/types:
    % SpeedtrackerConfig    for global and immutable (at least during one run of the program) constants

    properties (Constant)
        ERROR_SPEEDTRACKER_CONFIG_NOT_SET = "ConfigProvider:SpeedtrackerConfigNotSet"
    end

    methods (Static)
        % Get the SpeedtrackerConfig, which holds program-global, immutable constants
        % Errors:
        % E1 if the config has not been set by means of ConfigProvider.setSpeedtrackerConfig, throw an exception.
        function config = getSpeedtrackerConfig()
            config = ConfigProvider.getSetSpeedtrackerConfig();
        end

        % Set the SpeedtrackerConfig, which holds program-global, immutable constants
        function setSpeedtrackerConfig(newConfig)
            ConfigProvider.getSetSpeedtrackerConfig(newConfig);
        end

        function config = getSetSpeedtrackerConfig(newConfig)
            persistent speedtrackerConfig;
            if (nargin == 0 && isempty(speedtrackerConfig))
                throw(MException(ConfigProvider.ERROR_SPEEDTRACKER_CONFIG_NOT_SET, "SpeedtrackerConfig not set"));
            elseif (nargin == 0)
                config = speedtrackerConfig;
            else
                speedtrackerConfig = newConfig;
            end
        end
    end
end