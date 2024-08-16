classdef TestSensitivities < matlab.unittest.TestCase

    methods(TestClassSetup)
        function setup(~)
            cd("..");
            initPaths();
        end
    end
    
    methods(Test)
        function testCanonexVde(testCase)
            % Test the sensitivities generated with the VDE method on the canonical example.
            [integrator, options, t0, tEnd, p, x0] = getOdeDataForCanonex(testCase);
            datahandle = prepareDatahandleForIntegration( ...
                'canonicalExampleRHS', ...
                'solver', func2str(integrator), ...
                'options', options);
            sol = solveODE(datahandle, [t0 tEnd], x0, p);

            % Precision degrades at each switch. These are the highest orders of magnitude for which the
            % verifyEqual tests still passed.
            atol1 = 1e-5;
            atol2 = 1e-5;
            atol3 = 1e-3;

            FDstep = generateFDstep(size(sol.y,1), length(p));
            sensFun = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'VDE');

            t1 = sol.switches(1);
            t1Minus = t1-eps(t1-eps(t1));
            t2 = sol.switches(2);
            t2Minus = t2-eps(t2-eps(t2));
            T = [t0, t1Minus, t1, t2Minus, t2, tEnd];
            sens = sensFun(T);
            Gy = {sens.Gy};
            Gp = {sens.Gp};
            [Gy1, Gp1, Uy1, Up1, Gy2, Gp2, Uy2, Up2, Gy3, Gp3] = getSensitivitiesForCanonex(testCase, sol);

            % model 1
            testCase.verifyEqual(Gy{1}, Gy1(t0), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{1}, Gp1(t0), 'AbsTol', atol1);
            testCase.verifyEqual(Gy{2}, Gy1(t1Minus), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{2}, Gp1(t1Minus), 'AbsTol', atol1);
            testCase.verifyEqual(Gy{3}, Uy1 * Gy1(t1), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{3}, Uy1 * Gp1(t1) + Up1, 'AbsTol', atol1);

            % model 2
            testCase.verifyEqual(Gy{4}, Gy2(t2Minus), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{4}, Gp2(t2Minus), 'AbsTol', atol2);
            testCase.verifyEqual(Gy{5}, Uy2 * Gy2(t2), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{5}, Uy2 * Gp2(t2) + Up2, 'AbsTol', atol2);

            % model 3
            testCase.verifyEqual(Gy{6}, Gy3(tEnd), 'AbsTol', atol3);
            testCase.verifyEqual(Gp{6}, Gp3(tEnd), 'AbsTol', atol3);
        end

        function testCanonexEndPiecewise(testCase)
            % Test the sensitivities generated with the END_piecewise method on the canonical example.
            [integrator, options, t0, tEnd, p, x0] = getOdeDataForCanonex(testCase);
            datahandle = prepareDatahandleForIntegration( ...
                'canonicalExampleRHS', ...
                'solver', func2str(integrator), ...
                'options', options);
            sol = solveODE(datahandle, [t0 tEnd], x0, p);

            % Precision degrades at each switch. These are the highest orders of magnitude for which the
            % verifyEqual tests still passed. Unsurprisingly, these values are slightly worse than
            % those for VDE.
            atol1 = 1e-5;
            atol2 = 1e-4;
            atol3 = 1e-2;

            FDstep = generateFDstep(size(sol.y,1), length(p));
            sensFun = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_piecewise');

            t1 = sol.switches(1);
            t1Minus = t1-eps(t1-eps(t1));
            t2 = sol.switches(2);
            t2Minus = t2-eps(t2-eps(t2));
            T = [t0, t1Minus, t1, t2Minus, t2, tEnd];
            sens = sensFun(T);
            Gy = {sens.Gy};
            Gp = {sens.Gp};
            [Gy1, Gp1, Uy1, Up1, Gy2, Gp2, Uy2, Up2, Gy3, Gp3] = getSensitivitiesForCanonex(testCase, sol);

            % model 1
            testCase.verifyEqual(Gy{1}, Gy1(t0), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{1}, Gp1(t0), 'AbsTol', atol1);
            testCase.verifyEqual(Gy{2}, Gy1(t1Minus), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{2}, Gp1(t1Minus), 'AbsTol', atol1);
            testCase.verifyEqual(Gy{3}, Uy1 * Gy1(t1), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{3}, Uy1 * Gp1(t1) + Up1, 'AbsTol', atol1);

            % model 2
            testCase.verifyEqual(Gy{4}, Gy2(t2Minus), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{4}, Gp2(t2Minus), 'AbsTol', atol2);
            testCase.verifyEqual(Gy{5}, Uy2 * Gy2(t2), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{5}, Uy2 * Gp2(t2) + Up2, 'AbsTol', atol2);

            % model 3
            testCase.verifyEqual(Gy{6}, Gy3(tEnd), 'AbsTol', atol3);
            testCase.verifyEqual(Gp{6}, Gp3(tEnd), 'AbsTol', atol3);
        end

        function testCanonexEndFull(testCase)
            % Test the sensitivities generated with the END_full method on the canonical example.
            % Since this method does not support evaluating sensitivities near SWPs, we use ts+0.001*ts
            % instead of ts+eps(ts).
            [integrator, options, t0, tEnd, p, x0] = getOdeDataForCanonex(testCase);
            datahandle = prepareDatahandleForIntegration( ...
                'canonicalExampleRHS', ...
                'solver', func2str(integrator), ...
                'options', options);
            sol = solveODE(datahandle, [t0 tEnd], x0, p);

            % Precision degrades at each switch. These are the highest orders of magnitude for which the
            % verifyEqual tests still passed. These tolerances are as tight as with END_piecewise, but
            % note that we had to shift tSMinus and tSPlus farther away from the SWPs.
            atol1 = 1e-5;
            atol2 = 1e-4;
            atol3 = 1e-2;

            FDstep = generateFDstep(size(sol.y,1), length(p));
            sensFun = generateSensitivityFunction(datahandle, sol, FDstep, ...
                'method', 'END_full', 'CalcGy', true, 'CalcGp', true);

            t1 = sol.switches(1);
            % i had to shift these values by 1e-3 instead of eps, because END_full apparently causes
            % switches to shift in time.
            t1Plus = t1+1e-3*t1;
            t1Minus = t1-1e-3*t1;
            t2 = sol.switches(2);
            t2Plus = t2+1e-3*t2;
            t2Minus = t2-1e-3*t2;
            T = [t0, t1Minus, t1Plus, t2Minus, t2Plus, tEnd];
            sens = sensFun(T);
            Gy = {sens.Gy};
            Gp = {sens.Gp};
            [Gy1, Gp1, ~, ~, Gy2, Gp2, ~, ~, Gy3, Gp3] = getSensitivitiesForCanonex(testCase, sol);

            % model 1
            testCase.verifyEqual(Gy{1}, Gy1(t0), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{1}, Gp1(t0), 'AbsTol', atol1);
            testCase.verifyEqual(Gy{2}, Gy1(t1Minus), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{2}, Gp1(t1Minus), 'AbsTol', atol1);

            % model 2
            testCase.verifyEqual(Gy{3}, Gy2(t1Plus), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{3}, Gp2(t1Plus), 'AbsTol', atol2);
            testCase.verifyEqual(Gy{4}, Gy2(t2Minus), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{4}, Gp2(t2Minus), 'AbsTol', atol2);

            % model 3
            testCase.verifyEqual(Gy{5}, Gy3(t2Plus), 'AbsTol', atol3);
            testCase.verifyEqual(Gp{5}, Gp3(t2Plus), 'AbsTol', atol3);
            testCase.verifyEqual(Gy{6}, Gy3(tEnd), 'AbsTol', atol3);
            testCase.verifyEqual(Gp{6}, Gp3(tEnd), 'AbsTol', atol3);
        end
    end
    methods
        function [integrator, options, t0, tEnd, p, x0] = getOdeDataForCanonex(~)
            integrator = @ode45;
            options    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
            t0         = 0;
            tEnd       = 20;
            x0         = [1; 0];
            p          = 5.437;
        end
        function [Gy1, Gp1, Uy1, Up1, Gy2, Gp2, Uy2, Up2, Gy3, Gp3] = getSensitivitiesForCanonex(~, sol)
            % The matrices Gy and Uy computed derived analytically from the canonical example.

            % model 1
            t0   = sol.x(1);
            x0   = sol.y(:, 1);
            x2t0 = x0(2);
            Gy1  = @(t) [1 3*x2t0^2*(t-t0); 0 1];
            Gp1 = @(t) [0; 0];

            % update matrices at t1, model 2
            t1            = sol.switches(1);
            x2t1          = deval(sol, t1, 2);
            dSigmaMinust1 = 0.01*t1^2 + x2t1^3;
            Uy1           = [1 0; 5/dSigmaMinust1 1];
            Up1           = [0; -5/dSigmaMinust1];
            Gy2Intermed   = @(t) [1, 25*(t-t1)^3 + 15*x2t0*(t-t1)^2 + 3*x2t0^2*(t-t1); 0 1];
            Gy2           = @(t) Gy2Intermed(t) * Uy1 * Gy1(t1);
            Gp2Intermed   = @(t) [0; 0];
            Gp2           = @(t) Gy2Intermed(t) * (Uy1 * Gp1(t1) + Up1) + Gp2Intermed(t1);

            % update matrices at t2, model 3
            t2            = sol.switches(2);
            x2t2          = deval(sol,t2,2);
            dSigmaMinust2 = 0.01*t2^2 + x2t2^3;
            Uy2           = [1 0; -5/dSigmaMinust2 1];
            Up2           = [0; 5/dSigmaMinust2];
            Gy3Intermed   = @(t) [1 3*x2t2^2*(t-t2); 0 1];
            Gy3           = @(t) Gy3Intermed(t) * Uy2 * Gy2(t2);
            Gp3Intermed   = @(t) [0; 0];
            Gp3           = @(t) Gy3Intermed(t) * (Uy2 * Gp2(t2) + Up2) + Gp3Intermed(t2);
        end
    end
end