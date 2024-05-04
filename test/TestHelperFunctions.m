classdef TestHelperFunctions < matlab.unittest.TestCase
%TESTHELPERFUNCTIONS tests that various ways of using helper functions in RHSes work
    methods(TestClassSetup)
        % Shared setup for the entire test class
        function setup(~)
            cd("..");
            initPaths();
            addpath(genpath("test/TestHelperFunctions"))
        end
    end

    methods(TestMethodSetup)
        % Setup for each test
    end

    methods(Test)
        % Test methods
        function helperFunctionInElseBlock(this)
            %HELPERFUNCTIONINELSEBLOCK There is (2024-05-04) a bug where IFDIFF produces a syntactically invalid
            % switching function if an else block in the RHS contains a helper function that also has a switch in it.
            % It turns out the same bug happens if the helper function is in the if block.
            integrator = @ode45;
            odeoptions = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);

            datahandle = prepareDatahandleForIntegration('funinelse_RHS', ...
                                                         'solver', func2str(integrator), ...
                                                         'options', odeoptions);
            tEnd = 20;
            tspan         = [0 tEnd];
            initialvalues = 0;
            parameters    = 0;

            sol = solveODE(datahandle, tspan, initialvalues, parameters);
            yEnd = sol.y(:, end);
            this.verifyEqual(yEnd, 40, 'RelTol', 1e-6);
        end
    end
end