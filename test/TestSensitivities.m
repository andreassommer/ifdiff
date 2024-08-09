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

            % model 1
            atol1 = 1e-6;
            xt0 = x0(2);
            Gy_1 = @(t) [1 3*xt0^3*(t-t0); 0 1];
            testCase.verifyEqual(Gy{1}, Gy_1(t0), 'AbsTol', atol1);
            testCase.verifyEqual(Gy{2}, Gy_1(t1Minus), 'AbsTol', atol1);
            % update matrix at t1
            Uy_1 = [1 0; 5/(0.01*t1^2) 1];
            testCase.verifyEqual(Gy{3}, Uy_1 * Gy_1(t1), 'AbsTol', atol1);

            % model 2
            atol2 = 1e-5;
            Gy_2 = @(t) [1, 25*(t-t1)^3; 0 1] * Uy_1 * Gy_1(t1);
            testCase.verifyEqual(Gy{4}, Gy_2(t2Minus), 'AbsTol', atol2);

            xt2 = deval(sol,t2,2);
            Uy_2 = [1 0; -5/(0.01*t2^2 + xt2^3) 1];
            testCase.verifyEqual(Gy{5}, Uy_2 * Gy_2(t2), 'AbsTol', atol2);

            % model 3
            atol3 = 1e-3;
            Gy_3 = @(t) [1 3*xt2^2*(t-t2); 0 1] * Uy_2 * Gy_2(t2);
            testCase.verifyEqual(Gy{6}, Gy_3(tSpan(2)), 'AbsTol', atol3);
        end
    end
    
end