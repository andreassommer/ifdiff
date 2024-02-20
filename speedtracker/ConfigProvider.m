classdef ConfigProvider
    %ConfigProvider Provider for single instances of global configuration objects
    % Configuration objects/types:
    % SpeedtrackerConfig    for global and immutable (at least during one run of the program) constants

    properties (Constant)
        ERROR_SPEEDTRACKER_CONFIG_NOT_SET = "ConfigProvider:SpeedtrackerConfigNotSet"
        ERROR_USER_CONFIG_NOT_SET = "ConfigProvider:UserConfigNotSet"
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


        % Get the UserConfig, which holds user-settable configuration parameters
        % Errors:
        % E1 if the config has not been set by means of ConfigProvider.setUserConfig, throw an exception.
        function config = getUserConfig()
            config = ConfigProvider.getSetUserConfig();
        end

        % Set the UserConfig, which holds user-settable configuration parameters
        function setUserConfig(newConfig)
            ConfigProvider.getSetUserConfig(newConfig);
        end

        function config = getSetUserConfig(newConfig)
            persistent userConfig;
            if (nargin == 0 && isempty(userConfig))
                throw(MException(ConfigProvider.ERROR_USER_CONFIG_NOT_SET, "UserConfig not set"));
            elseif (nargin ==0)
                config = userConfig;
            else
                userConfig = newConfig;
            end
        end
    end
end