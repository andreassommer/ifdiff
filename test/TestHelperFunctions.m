classdef TestHelperFunctions < matlab.unittest.TestCase
    %TESTHELPERFUNCTIONS tests that various ways of using helper functions in RHSes work
    methods(TestClassSetup)
        function setPath(testCase)
            originalPath = path;
            testCase.addTeardown(@path, originalPath);

            if ~exist('initPaths', 'file')
                % We are probably in the test directory, so check parent directory
                cd('..');
            end
            initPaths();

            % Get absolute path to directory in which this file resides.
            [filePath, ~, ~] = fileparts(mfilename('fullpath'));
            addpath(fullfile(filePath, 'TestHelperFunctions'));
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

            datahandle = prepareDatahandleForIntegration( ...
                'funinelse_RHS', ...
                'integrator', func2str(integrator), ...
                'options', odeoptions);
            tEnd = 20;
            tspan         = [0 tEnd];

            sol = solveODE(datahandle, tspan, 0, 0);
            yEnd = sol.y(:, end);
            this.verifyEqual(yEnd, 40, 'RelTol', 1e-6);
        end

        function manyFunctions(this)
            %MANYFUNCTIONS the final boss: a function with helper functions in conditions, in if/else bodies, and
            % helper functions within helper functions.
            integrator = @ode45;
            odeoptions = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);

            datahandle = prepareDatahandleForIntegration( ...
                'manyFunctions', ...
                'integrator', func2str(integrator), ...
                'options', odeoptions);
            tEnd = 30;
            tspan         = [0 tEnd];

            sol = solveODE(datahandle, tspan, 0, 0);
            y = deval(sol, [10 20 30]);
            this.verifyEqual(y, [10, 25, 30],  'RelTol', 1e-6);
        end
    end
end