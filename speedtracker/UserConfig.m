classdef UserConfig
    %USERCONFIG Holder for user-configurable custom properties.
    %   You can edit this file to set default values. Some properties can be overridden by passing parameters to
    %   the commands that depend on them. A property ConfigOption also has associated static methods
    %   checkConfigOption and describeBadConfigOption for validating it and describing what it should look like if a
    %   user passes a bad value.
    properties (Access=public)
        % Output format for benchmark results. value: 'Raw' | 'OneTable', default 'OneTable'.
        % Used by RunCommand.
        OutputType = Configuration.OutputType;
        % Relative tolerance for solution values at the end of the time horizon and for switching points.
        % compareIfdiffSols compares whether the last y values and switching points of two sol objects were the
        % same, using this value as the relative tolerance.
        % See also COMPAREIFDIFFSOLS
        YEndTol = Configuration.YEndTol;
    end

    properties (Constant, Access=private)
        OutputTypeValues = {'Raw', 'OneTable'};
    end

    methods
        function obj = UserConfig()
        end
        function obj = set.OutputType(obj, value)
            value = string(value);
            assert(UserConfig.checkOutputType(value));
            obj.OutputType = value;
        end

        function obj = set.YEndTol(obj, value)
            assert(UserConfig.checkYEndTol(value));
            obj.YEndTol = value;
        end
    end

    methods (Static)
        function isValid = checkOutputType(value)
            % Verify that a value is a valid setting for OutputType
            isValid = StringUtil.isSimpleString(value) && ismember( ...
                lower(value), cellfun(@lower, UserConfig.OutputTypeValues, 'UniformOutput', false));
        end
        function message = describeBadOutputType(value)
            disp(value)
            % Given an invalid value for OutputType, return a message describing why it is not valid
            if (isstring(value))
                message = sprintf('OutputType expects one of %s, but got %s', ...
                    strjoin(UserConfig.OutputTypeValues, ' | '), StringUtil.toStr(value));
            else
                message = sprintf('OutputType expects one of %s, but value has type %s', ...
                    strjoin(UserConfig.OutputTypeValues, ' | '), class(value));
            end
        end

        function isValid = checkYEndTol(value)
            % Check if a value is a valid setting for YEndTol
            isValid = isnumeric(value) && length(value) == 1;
        end
        function message = describeBadYEndTol(value)
            % Given an invalid value for YEndTol, describe why it is invalid
            % Will not work properly if you pass in a valid YEndtol value.
            if isnumeric(value)
                message = sprintf('expecting scalar, but got dimensions %s', StringUtil.dimStr(value));
            else
                message = sprintf('expecting numeric type, but got %s', class(value));
            end
        end
    end
end