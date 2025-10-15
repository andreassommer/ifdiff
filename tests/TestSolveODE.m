classdef TestSolveODE < matlab.unittest.TestCase
    %TESTSOLVEODE
    %
    %Test special cases for solving ODEs with IFDIFF.

    methods (TestClassSetup)
        function setPath(testCase)
            import matlab.unittest.fixtures.PathFixture

            testCase.applyFixture(PathFixture('data/TestSolveODE'));
        end
    end

    methods (Test)
        function testNoSwitchRhs(testCase)
            %TESTNOSWITCHRHS
            %
            %Solve ODE RHS without switches. Also compute sensitivities.
            %ODE solution should be identity y(t) = t.
            %Sensitivity w.r.t. y0 should be Gy(t) = 1.

            % Check for user warning.
            testCase.verifyWarning(@() prepareDatahandleForIntegration(@noSwitchRHS), 'IFDIFF:Preprocessing:NoCtrlif');

            % Check solution.
            atol = 1e-8;
            rtol = 1e-10;
            opts = odeset('AbsTol', atol, 'RelTol', rtol);
            datahandle = prepareDatahandleForIntegration(@noSwitchRHS, 'options', opts);

            tspan = [0, 5];
            x0 = 0;
            p = [];
            sol = solveODE(datahandle, tspan, x0, p);
            tEval = linspace(tspan(1), tspan(end), 100);
            yEval = deval(sol, tEval);
            % y(t) = t
            testCase.verifyEqual(tEval, yEval, 'AbsTol', atol, 'RelTol', rtol);

            % Check sensitivity w.r.t. y0.
            yDim = size(sol.y, 1);
            pDim = length(p);
            FDstep = generateFDstep(yDim, pDim);
            sensFun = generateSensitivityFunction(datahandle, sol, FDstep, 'calcGp', false);
            sens = sensFun(tEval);
            Gy = arrayfun(@(x) x.Gy, sens);
            % Gy(t) = 1
            testCase.verifyEqual(Gy, ones(size(Gy)), 'AbsTol', atol, 'RelTol', rtol);
        end
    end
end
