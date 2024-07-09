classdef TestStateJumps < matlab.unittest.TestCase

    methods(TestClassSetup)
        % Shared setup for the entire test class
        function setup(~)
            cd("..");
            initPaths();
            addpath(genpath("test/TestStateJumps"));
        end
    end

    methods(TestMethodSetup)
        % Setup for each test
    end

    methods(Test)
        % Test methods

        function testIdenticalIfs(testCase)
            % Test a RHS with two ifs that have the same SWF.
            integrator = @ode45;
            options    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
            datahandle = prepareDatahandleForIntegration( ...
                'identicalIfRHS', ...
                'integrator', func2str(integrator), ...
                'options', options);
            t0 = 0;
            tEnd = 3;
            x0 = [1; 0];
            p = [0.1, 2];
            sol = solveODE(datahandle, [t0 tEnd], x0, p);
            % See identicalIfRHS for the derivation of these expected values
            testCase.verifyEqual(deval(sol, 1), [exp(1); 2], 'RelTol', 1e-5);
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
    end

end