classdef TestSolveODE < matlab.unittest.TestCase
    %TESTSOLVEODE
    %
    %Test special cases for solving ODEs with IFDIFF.

    properties (TestParameter)
        rhsElseif = { ...
            @canonicalExampleElseifRHS, ... % Standard reformulation with elseif
            @canonicalExampleElseifMultipleRHS, ... % Redundant elseif before and after original
            @canonicalExampleElseifMultipleNestedRHS, ... % Redundant nested elseif
            @canonicalExampleElseifIgnoreRHS, ... % Ignored elseif
            @canonicalExampleElseifHelperRHS}; % Elseif in helper functions
    end

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

        function testElseif(testCase, rhsElseif)
            %TESTELSEIF(testCase, rhsElseif)
            %
            %Solve canonical example rewritten using elseif syntax.
            %Compare with analytic solution.
            %
            %INPUT:
            %   rhsElseif - RHS representing canonical example with elseif.
            %   See test parameter definition in properties for details.
            %       function_handle

            % Get true solution
            [solTrue, switchTrue, ~, t0, y0, p] = canonicalExampleAnalyticSolution;

            % Compute solution with IFDIFF
            % Make sure we integrate a little further than the last switch
            tFac = 0.1;
            tf = switchTrue(end) + tFac*(switchTrue(end)-t0);
            tspan = [t0, tf];

            atol = 1e-13;
            rtol = 1e-13;
            opts = odeset('AbsTol', atol, 'RelTol', rtol);
            datahandle = prepareDatahandleForIntegration(rhsElseif, 'integrator', @ode45, 'options', opts);

            sol = solveODE(datahandle, tspan, y0, p);

            % Check solution
            tEval = linspace(tspan(1), tspan(end), 1000);
            yEval = deval(sol, tEval);
            yTrue = solTrue(tEval);
            testCase.verifyEqual(yEval, yTrue, 'AbsTol', atol, 'RelTol', rtol);

            % Check switching times
            testCase.verifyEqual(sol.switches, switchTrue, 'AbsTol', atol, 'RelTol', rtol);
        end
    end
end
