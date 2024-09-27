classdef TestStateJumps < matlab.unittest.TestCase

    properties (Constant)
        defaultIntegrator = @ode45;
    end

    methods(TestClassSetup)
        % Shared setup for the entire test class
        function setup(testCase)
            originalPath = path;
            testCase.addTeardown(@path, originalPath);

            if ~exist('initPaths', 'file')
                % We are probably in the test directory, so check parent directory
                cd('..');
            end
            initPaths();

            % Get absolute path to directory in which initPaths resides.
            % This should be the IFDIFF project root directory.
            [filePath, ~, ~] = fileparts(which('initPaths'));
            addpath(fullfile(filePath, 'test', 'TestStateJumps'));
        end
    end

    methods(TestMethodSetup)
        % Setup for each test
    end

    methods(Test)
        % Test methods

        function testIdenticalIfs(testCase)
            % Test a RHS with two ifs that have the same SWF.
            integrator = TestStateJumps.defaultIntegrator;
            options    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
            datahandle = prepareDatahandleForIntegration( ...
                'identicalIfRHS', ...
                'solver', func2str(integrator), ...
                'options', options);
            t0 = 0;
            tEnd = 3;
            x0 = [1; 0];
            p = [0.1, 2];
            sol = solveODE(datahandle, [t0 tEnd], x0, p);
            % See identicalIfRHS for the derivation of these expected values
            testCase.verifyEqual(sol.switches(1), 1, 'RelTol', 1e-5);
            testCase.verifyEqual(deval(sol, sol.switches(1)), [exp(1); 2], 'RelTol', 1e-5);
            testCase.verifyEqual(deval(sol, 2), [exp(1.1); 3], 'RelTol', 1e-5);
            testCase.verifyEqual(deval(sol, 3), [exp(1.2); 4], 'RelTol', 1e-5);
            testCase.verifyEqual(sol.switches, 1, 'AbsTol', 1e-5);
            % Sensitivities. See identicalIfRHS for the derivation of the expected value
            FDstep = generateFDstep(2, 2);
            sensFunction = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'VDE');
            T = t0:0.01:tEnd;
            sens = sensFunction(T);
            Gp = {sens.Gp};
            Gp11 = cellfun(@(x) x(1,1), Gp);
            testCase.verifyEqual(Gp11(end), 2*exp(1.2), 'RelTol', 1e-5);
        end

        function testTwoJumpsOppositeDirections(testCase)
            % Test an RHS that has two jumps with the same switching function, but opposite direction
            % flags.
            integrator = TestStateJumps.defaultIntegrator;
            options    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
            datahandle = prepareDatahandleForIntegration( ...
                'twoJumpsGoodRHS', ...
                'solver', func2str(integrator), ...
                'options', options);
            t0 = 0;
            tEnd = 4.1; % switches at tEnd exactly unfortunately aren't handled too gracefully
            x0 = 1;
            p = 0;
            sol = solveODE(datahandle, [t0 tEnd], x0, p);
            % (mainly just test that it doesn't crash) and use abstol where the actual value is 0
            testCase.verifyEqual(deval(sol, 2.5), 0.5, 'RelTol', 1e-8);
            testCase.verifyEqual(deval(sol, 3.5), -0.5, 'RelTol', 1e-8);

            expectedSwitches = [1,  2,  3, 4;
                                -1, 1, -1, 1];
            for i=1:length(expectedSwitches)
                testCase.verifyEqual(sol.switches(i), expectedSwitches(1, i), 'RelTol', 1e-6);
                testCase.verifyEqual(deval(sol, sol.switches(i)), expectedSwitches(2, i), 'RelTol', 1e-6);
            end
        end

        function testTwoJumpsSameDirection(testCase)
            % Test an RHS that has two jumps that overlap - this should throw an error
            integrator = TestStateJumps.defaultIntegrator;
            options = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);

            t0 = 0;
            tF = 10;
            p = 0;
            x0 = 4;

            datahandle = prepareDatahandleForIntegration( ...
                'twoJumpsBadRHS', ...
                'solver', func2str(integrator), ...
                'options', options);

            testCase.verifyError(@() solveODE(datahandle, [t0 tF], x0, p), '');
        end

        function testJumpChangesModel(testCase)
            % Test an RHS that enters one model and then performs a jump into yet another model
            integrator = TestStateJumps.defaultIntegrator;
            options    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
            datahandle = prepareDatahandleForIntegration( ...
                'jumpChangesModelRHS', ...
                'solver', func2str(integrator), ...
                'options', options);
            t0 = 0;
            tEnd = 4;
            x0 = [0; 0];
            p = 2;
            sol = solveODE(datahandle, [t0 tEnd], x0, p);
            % at t=2, x(1) jumps from 4 to 13 and x(2) = 4.
            testCase.verifyEqual(deval(sol, tEnd, 1), 17, 'RelTol', 1e-5);
            testCase.verifyEqual(deval(sol, tEnd, 2), 0, 'AbsTol', 1e-5);
        end

        function testJumpInHelper(testCase)
            % Test an RHS where there are jumps in helper functions
            integrator = TestStateJumps.defaultIntegrator;
            options    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
            datahandle = prepareDatahandleForIntegration( ...
                'jumpInHelperRHS', ...
                'solver', func2str(integrator), ...
                'options', options);
            t0 = 0;
            tEnd = 25;
            p = 0;
            x0 = 0;
            sol = solveODE(datahandle, [t0 tEnd], x0, p);
            % the first switch is a pure jump, the second a pure model switch, the third a full switch.
            expectedSwitches = [5 10 15; 10 15 30];
            for i=1:length(expectedSwitches)
                testCase.verifyEqual(sol.switches(i), expectedSwitches(1, i), 'RelTol', 1e-6);
                testCase.verifyEqual(deval(sol, sol.switches(i)), expectedSwitches(2, i), 'RelTol', 1e-6);
            end
            testCase.verifyEqual(deval(sol, 25), 40, 'RelTol', 1e-6);
        end

        function testJumpInHelperWithJumpsDisabled(testCase)
            % Test that everything works with jump handling disabled
            config = makeConfig();
            config.jump.disable = true;
            makeConfig(config);

            integrator = TestStateJumps.defaultIntegrator;
            options    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
            datahandle = prepareDatahandleForIntegration( ...
                'jumpInHelperRHS', ...
                'solver', func2str(integrator), ...
                'options', options);
            t0 = 0;
            tEnd = 25;
            p = 0;
            x0 = 0;
            sol = solveODE(datahandle, [t0 tEnd], x0, p);
            testCase.verifyEqual(deval(sol, 5), 5, 'RelTol', 1e-6);
            testCase.verifyEqual(deval(sol, 15), 15, 'RelTol', 1e-6);
            testCase.verifyEqual(deval(sol, 25), 30, 'RelTol', 1e-6);

            config.jump.disable = false;
            makeConfig(config);
        end

        function testBounceball(testCase)
            % Test the bouncing ball example. See RHS file for explanation on where these expected values come from
            integrator = TestStateJumps.defaultIntegrator;
            options    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
            datahandle = prepareDatahandleForIntegration( ...
                'bounceballRHS', ...
                'solver', func2str(integrator), ...
                'options', options);
            g     = 9.807;
            gamma = 0.9;
            v0 = 10;
            p = [g gamma];

            t0 = 0;
            tEnd = 8;
            x0 = [0; v0];
            sol = solveODE(datahandle, [t0 tEnd], x0, p);
            expectedSwitches = (2*v0/g)*[1 (1+gamma) (1+gamma+gamma^2) (1+gamma+gamma^2+gamma^3)];
            for i=1:length(expectedSwitches)
                ts = sol.switches(i);
                % Since the solution is discontinuous at the switching points, an imperfect calculation of
                % the SWP can cause deval(sol, expectedSwitches(i)) to be way wrong. Instead, we deval
                % at the actual switch, and compare the switching _time_ to the expected time.
                testCase.verifyEqual(ts, expectedSwitches(i), 'RelTol', 1e-6);
                testCase.verifyEqual(deval(sol, ts, 1), 0, 'AbsTol', 1e-6);
                testCase.verifyEqual(deval(sol, ts, 2), gamma^i*v0, 'RelTol', 1e-6);
            end
        end
    end
end