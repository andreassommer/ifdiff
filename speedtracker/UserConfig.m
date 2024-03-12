classdef UserConfig
    %USERCONFIG Holder for user-configurable custom properties.
    %   You can edit this file to set default values. Some properties can be overridden by passing parameters to
    %   the commands that depend on them. A property ConfigOption also has associated static methods
    %   checkConfigOption and describeBadConfigOption for validating it and describing what it should look like if a
    %   user passes a bad value.
    properties (Access=public)
        % Output format for benchmark results. value: "Raw" | "OneTable" | "NTables", default "OneTable".
        % Used by RunCommand.
        OutputType = Configuration.OutputType;
    end

    properties (Constant, Access=private)
        OutputTypeValues = ["Raw", "OneTable", "NTables"];
    end

    methods
        function obj = UserConfig()
        end
        function obj = set.OutputType(obj, value)
            value = string(value);
            assert(UserConfig.checkOutputType(value));
            obj.OutputType = value;
        end
    end

    methods (Static)
        function isValid = checkOutputType(value)
            % Verify that a value is a valid setting for OutputType
            isValid = ismember(lower(value), arrayfun(@lower, UserConfig.OutputTypeValues));
        end
        function message = describeBadOutputType(value)
            % Given an invalid value for OutputType, return a message describing why it is not valid
            if (isstring(value))
                message = sprintf("OutputType expects one of %s, but got %s", ...
                    strjoin(UserConfig.OutputTypeValues, " | "), StringUtil.toStr(value));
            else
                message = sprintf("OutputType expects one of %s, but value has type %s", ...
                    strjoin(UserConfig.OutputTypeValues, "|"), class(value));
            end
        end
    end
end