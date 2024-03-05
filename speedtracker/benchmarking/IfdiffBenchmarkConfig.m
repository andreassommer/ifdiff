classdef IfdiffBenchmarkConfig
    %IFDIFFBENCHMARKCONFIG Configuration options specific to IfdiffBenchmarkRunner. These are user-settable, global,
    % and should be immutable through the course of one program execution. As such, they would thematically fit into
    % UserConfig, however we want to ensure that all IFDIFF-specific benchmarking code is boxed in as much as
    % possible to ease porting Speedtracker for testing other MATLAB libraries.
    
    properties
        % Relative tolerance for final x (solution) values. Benchmark results contain a flag for whether a given
        % solution's final x value differs from the previous value. This value sets the relative tolerance for
        % that flag.
        XEndTol = Configuration.XEndTol;
    end
    
    methods
        function obj = IfdiffBenchmarkConfig()
        end

        function obj = set.XEndTol(obj, value)
            assert(IfdiffBenchmarkConfig.checkXEndTol(value));
            obj.XEndTol = value;
        end
    end

    methods (Static)
        function isValid = checkXEndTol(value)
            isValid = isnumeric(value) && length(value) == 1;
        end
        function message = describeBadXEndTol(value)
            if isnumeric(value)
                message = sprintf("XEndTol expects scalar, but got dimensions %s", strjoin(string(size(value), ", ")));
            else
                message = sprintf("XEndTol expects double, but got %s", class(value));
            end
        end

    end
end

