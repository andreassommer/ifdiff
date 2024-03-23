classdef ConfigProvider
    %ConfigProvider Provider for single instances of global configuration objects
    % Configuration objects/types:
    % SpeedtrackerConfig    for global and immutable (at least during one run of the program) constants

    properties (Constant)
        ERROR_SPEEDTRACKER_CONFIG_NOT_SET = 'ConfigProvider:SpeedtrackerConfigNotSet'
        ERROR_USER_CONFIG_NOT_SET = 'ConfigProvider:UserConfigNotSet'
    end

    methods (Static)
        function config = getSpeedtrackerConfig()
            % Get the SpeedtrackerConfig, which holds program-global, immutable constants
            % Errors:
            % E1 if the config has not been set by means of ConfigProvider.setSpeedtrackerConfig, throw an exception.
            config = ConfigProvider.getSetSpeedtrackerConfig();
        end

        function setSpeedtrackerConfig(newConfig)
            % Set the SpeedtrackerConfig, which holds program-global, immutable constants.
            % Should only ever be done once by main function right at the start of program execution.
            ConfigProvider.getSetSpeedtrackerConfig(newConfig);
        end


        function config = getUserConfig()
            % Get the UserConfig, which holds user-settable, global configuration parameters
            % Errors:
            % E1 if the config has not been set by means of ConfigProvider.setUserConfig, throw an exception.
            config = ConfigProvider.getSetUserConfig();
        end

        function setUserConfig(newConfig)
            % Set the UserConfig, which holds user-settable configuration parameters.
            % These parameters can be overridden
            % by the user at runtime, but they are constant and global during one run of the program. As such,
            % this method may be used at the start of a UserCommand's execute() method, but only once.
            ConfigProvider.getSetUserConfig(newConfig);
        end
    end

    methods (Static, Access=private)
        function config = getSetSpeedtrackerConfig(newConfig)
            persistent speedtrackerConfig;
            if (nargin == 0 && isempty(speedtrackerConfig))
                throw(MException(ConfigProvider.ERROR_SPEEDTRACKER_CONFIG_NOT_SET, 'SpeedtrackerConfig not set'));
            elseif (nargin == 0)
                config = speedtrackerConfig;
            else
                speedtrackerConfig = newConfig;
            end
        end

        function config = getSetUserConfig(newConfig)
            persistent userConfig;
            if (nargin == 0 && isempty(userConfig))
                throw(MException(ConfigProvider.ERROR_USER_CONFIG_NOT_SET, 'UserConfig not set'));
            elseif (nargin ==0)
                config = userConfig;
            else
                userConfig = newConfig;
            end
        end
    end
end