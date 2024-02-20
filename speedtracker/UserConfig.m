classdef UserConfig
    %USERCONFIG Holder for user-configurable custom properties.
    %   You can edit this file to set default values. Some properties can be overridden by passing parameters to
    %   the commands that depend on them. A property ConfigOption also has associated static methods
    %   checkConfigOption and describeBadConfigOption for validating it and describing what it should look like if a
    %   user passes a bad value.
    properties (Access=public)
        % Output format for benchmark results. value: "Raw" | "OneTable" | "NTables", default "OneTable".
        % Used by RunCommand.
        OutputType = "OneTable"
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
            isValid = ismember(value, UserConfig.OutputTypeValues);
        end
        function message = describeBadOutputType(value)
            if (isstring(value))
                message = sprintf("expected one of %s, but got %s", ...
                    strjoin(UserConfig.OutputTypeValues, " | "), StringUtil.toStr(value));
            else
                message = sprintf("expected one of %s, but value has type %s", ...
                    strjoin(UserConfig.OutputTypeValues, "|"), class(value));
            end
        end
    end
end