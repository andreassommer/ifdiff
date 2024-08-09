classdef TestSensitivities < matlab.unittest.TestCase

    properties (SetAccess=immutable)
        canonexTSpan   = [0 20];
        canonexX0      = [1; 0];
        canonexP       = 5.437;
        canonexSolver  = 'ode45';
        canonexOptions = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
    end

    methods(TestClassSetup)
        function setup(~)
            cd("..");
            initPaths();
        end
    end
    
    methods(Test)
        function testCanonexVde(testCase)
            % Test the sensitivities generated with the VDE method on the canonical example.
            % The matrices Gy and Uy computed here are derived analytically from the canonical example.
            tSpan = testCase.canonexTSpan;
            x0    = testCase.canonexX0;
            p     = testCase.canonexP;
            datahandle = prepareDatahandleForIntegration( ...
                'canonicalExampleRHS', ...
                'solver', testCase.canonexSolver, ...
                'options', testCase.canonexOptions);
            sol = solveODE(datahandle, tSpan, x0, p);

            % Precision degrades at each switch.
            atol1 = 1e-5;
            atol2 = 1e-5;
            atol3 = 1e-3;

            dim_y  = size(sol.y,1);
            dim_p  = length(p);
            FDstep = generateFDstep(dim_y,dim_p);
            sensFun = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'VDE');

            t0 = tSpan(1);
            t1 = sol.switches(1);
            t1Minus = t1-eps(t1-eps(t1));
            t2 = sol.switches(2);
            t2Minus = t2-eps(t2-eps(t2));
            T = [tSpan(1), t1Minus, t1, t2Minus, t2, tSpan(2)];
            sens = sensFun(T);
            Gy = {sens.Gy};
            Gp = {sens.Gp};

            % model 1
            x2t0 = x0(2);
            Gy_1 = @(t) [1 3*x2t0^2*(t-t0); 0 1];
            % continuous p-sensitivities are always 0, since f does not depend on p. only SWPs affect p sensitivity
            Gp_1 = @(t) [0; 0];
            testCase.verifyEqual(Gy{1}, Gy_1(t0), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{1}, Gp_1(t0), 'AbsTol', atol1);
            testCase.verifyEqual(Gy{2}, Gy_1(t1Minus), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{2}, Gp_1(t1Minus), 'AbsTol', atol1);
            % update matrices at t1
            x2t1 = deval(sol, t1, 2);
            dSigmaMinust1 = 0.01*t1^2 + x2t1^3;
            Uy_1 = [1 0; 5/dSigmaMinust1 1];
            Up_1 = [0; -5/dSigmaMinust1];
            testCase.verifyEqual(Gy{3}, Uy_1 * Gy_1(t1), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{3}, Uy_1 * Gp_1(t1) + Up_1, 'AbsTol', atol1);

            % model 2
            Gy_2 = @(t) [1, 25*(t-t1)^3 + 15*x2t0*(t-t1)^2 + 3*x2t0^2*(t-t1); 0 1];
            Gy_2_full = @(t) Gy_2(t) * Uy_1 * Gy_1(t1);
            Gp_2 = @(t) [0; 0];
            Gp_2_full = @(t) Gy_2(t) * (Uy_1 * Gp_1(t1) + Up_1) + Gp_2(t1);
            testCase.verifyEqual(Gy{4}, Gy_2_full(t2Minus), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{4}, Gp_2_full(t2Minus), 'AbsTol', atol2);
            % update matrices at t2
            x2t2 = deval(sol,t2,2);
            dSigmaMinust2 = 0.01*t2^2 + x2t2^3;
            Uy_2 = [1 0; -5/dSigmaMinust2 1];
            Up_2 = [0; 5/dSigmaMinust2];
            testCase.verifyEqual(Gy{5}, Uy_2 * Gy_2_full(t2), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{5}, Uy_2 * Gp_2_full(t2) + Up_2, 'AbsTol', atol2);

            % model 3
            Gy_3 = @(t) [1 3*x2t2^2*(t-t2); 0 1];
            Gy_3_full = @(t) Gy_3(t) * Uy_2 * Gy_2_full(t2);
            Gp_3 = @(t) [0; 0];
            Gp_3_full = @(t) Gy_3(t) * (Uy_2 * Gp_2_full(t2) + Up_2) + Gp_3(t2);
            testCase.verifyEqual(Gy{6}, Gy_3_full(tSpan(2)), 'AbsTol', atol3);
            testCase.verifyEqual(Gp{6}, Gp_3_full(tSpan(2)), 'AbsTol', atol3);
        end

        function testCanonexEndPiecewise(testCase)
            % Test the sensitivities generated with the END_piecewise method on the canonical example.
            % The matrices Gy and Uy computed here are derived analytically from the canonical example.
            tSpan = testCase.canonexTSpan;
            x0    = testCase.canonexX0;
            p     = testCase.canonexP;
            datahandle = prepareDatahandleForIntegration( ...
                'canonicalExampleRHS', ...
                'solver', testCase.canonexSolver, ...
                'options', testCase.canonexOptions);
            sol = solveODE(datahandle, tSpan, x0, p);

            % Precision degrades at each switch. Note that these values are slightly worse than
            % those for VDE.
            atol1 = 1e-5;
            atol2 = 1e-4;
            atol3 = 1e-2;

            dim_y  = size(sol.y,1);
            dim_p  = length(p);
            FDstep = generateFDstep(dim_y,dim_p);
            sensFun = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_piecewise');

            t0 = tSpan(1);
            t1 = sol.switches(1);
            t1Minus = t1-eps(t1-eps(t1));
            t2 = sol.switches(2);
            t2Minus = t2-eps(t2-eps(t2));
            T = [tSpan(1), t1Minus, t1, t2Minus, t2, tSpan(2)];
            sens = sensFun(T);
            Gy = {sens.Gy};
            Gp = {sens.Gp};

            % model 1
            x2t0 = x0(2);
            Gy_1 = @(t) [1 3*x2t0^2*(t-t0); 0 1];
            % continuous p-sensitivities are always 0, since f does not depend on p. only SWPs affect p sensitivity
            Gp_1 = @(t) [0; 0];
            testCase.verifyEqual(Gy{1}, Gy_1(t0), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{1}, Gp_1(t0), 'AbsTol', atol1);
            testCase.verifyEqual(Gy{2}, Gy_1(t1Minus), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{2}, Gp_1(t1Minus), 'AbsTol', atol1);
            % update matrices at t1
            x2t1 = deval(sol, t1, 2);
            dSigmaMinust1 = 0.01*t1^2 + x2t1^3;
            Uy_1 = [1 0; 5/dSigmaMinust1 1];
            Up_1 = [0; -5/dSigmaMinust1];
            testCase.verifyEqual(Gy{3}, Uy_1 * Gy_1(t1), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{3}, Uy_1 * Gp_1(t1) + Up_1, 'AbsTol', atol1);

            % model 2
            Gy_2 = @(t) [1, 25*(t-t1)^3 + 15*x2t0*(t-t1)^2 + 3*x2t0^2*(t-t1); 0 1];
            Gy_2_full = @(t) Gy_2(t) * Uy_1 * Gy_1(t1);
            Gp_2 = @(t) [0; 0];
            Gp_2_full = @(t) Gy_2(t) * (Uy_1 * Gp_1(t1) + Up_1) + Gp_2(t1);
            testCase.verifyEqual(Gy{4}, Gy_2_full(t2Minus), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{4}, Gp_2_full(t2Minus), 'AbsTol', atol2);
            % update matrices at t2
            x2t2 = deval(sol,t2,2);
            dSigmaMinust2 = 0.01*t2^2 + x2t2^3;
            Uy_2 = [1 0; -5/dSigmaMinust2 1];
            Up_2 = [0; 5/dSigmaMinust2];
            testCase.verifyEqual(Gy{5}, Uy_2 * Gy_2_full(t2), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{5}, Uy_2 * Gp_2_full(t2) + Up_2, 'AbsTol', atol2);

            % model 3
            Gy_3 = @(t) [1 3*x2t2^2*(t-t2); 0 1];
            Gy_3_full = @(t) Gy_3(t) * Uy_2 * Gy_2_full(t2);
            Gp_3 = @(t) [0; 0];
            Gp_3_full = @(t) Gy_3(t) * (Uy_2 * Gp_2_full(t2) + Up_2) + Gp_3(t2);
            testCase.verifyEqual(Gy{6}, Gy_3_full(tSpan(2)), 'AbsTol', atol3);
            testCase.verifyEqual(Gp{6}, Gp_3_full(tSpan(2)), 'AbsTol', atol3);
        end
    end
    
end