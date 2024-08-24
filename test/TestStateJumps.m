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
            h0 = eps(1)*(1/g) * v0^2;
            p = [g gamma];

            t0 = 0;
            tEnd = 10;
            x0 = [h0; v0];
            sol = solveODE(datahandle, [t0 tEnd], x0, p);

            % expect four switching points. If you change tEnd, then also change these
            expectedSwitches = testCase.bounceballSwitches(6, v0, g, gamma);
            atol             = [1e-6 1e-6 1e-6 1e-6 1e-6 1e-6];

            % Prepare the sensitivities at t- and t for each switch
            switchesLeft = sol.switches - eps(sol.switches - eps(sol.switches));
            sensTimes = reshape([switchesLeft; sol.switches], 1, []);
            sensTimes = [t0 sensTimes tEnd];
            fdStep = generateFDstep(length(x0), length(p));
            sensFun = generateSensitivityFunction(datahandle, sol, fdStep, 'method', 'VDE', ...
                'CalcGy', true, 'CalcGp', true, 'Gmatrices_intermediate', true);
            sens = sensFun(sensTimes);
            Gy = {sens.Gy};
            Gp = {sens.Gp};

            Gy_prev = eye(length(x0));
            Gp_prev = zeros(length(x0), length(p));
            for i=1:length(sol.switches)
                % t2 is the current switch, t1 is the previous one
                t1  = sensTimes(2*i-1);
                t2Minus = sensTimes(2*i);
                t2 = sol.switches(i);
                % switching time and solution value
                testCase.verifyEqual(t2, expectedSwitches(i), 'RelTol', 1e-6);
                testCase.verifyEqual(deval(sol, t2, 1), 0, 'AbsTol', 1e-6);
                testCase.verifyEqual(deval(sol, t2, 2), gamma^i*v0, 'RelTol', 1e-6);
                % sensitivities
                [Gy_t2_t1, Gp_t2_t1, Uy_t2, Up_t2] = testCase.bounceballIntermediateSensitivities(sol, p, t1, t2Minus);
                Gy_full = Gy_t2_t1 * Gy_prev;
                Gp_full = Gy_t2_t1 * Gp_prev + Gp_t2_t1;
                testCase.verifyEqual(Gy{2*i}, Gy_full, 'AbsTol', atol(i));
                testCase.verifyEqual(Gp{2*i}, Gp_full, 'AbsTol', atol(i));
                Gy_prev = Uy_t2 * Gy_full;
                Gp_prev = Uy_t2 * Gp_full + Up_t2;
                testCase.verifyEqual(Gy{2*i+1}, Gy_prev, 'AbsTol', atol(i));
                testCase.verifyEqual(Gp{2*i+1}, Gp_prev, 'AbsTol', atol(i));
            end
        end
        function testSensitivitiesSimpleVDE(testCase)
            % Test sensitivity computation across jumps using the simple, one-dimensional jumpSensitivityRHS.
            [integrator, options, t0, tEnd, p, x0] = testCase.getOdeDataForJumpSensitivityRHS();
            datahandle = prepareDatahandleForIntegration( ...
                'jumpSensitivityRHS', ...
                'solver', func2str(integrator), ...
                'options', options);
            sol = solveODE(datahandle, [t0 tEnd], x0, p);
            testCase.verifyEqual(length(sol.switches), 1);

            atol1 = 1e-6;
            atol2 = 1e-5;

            FDstep = generateFDstep(size(sol.y,1), length(p));
            sensFun = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'VDE', ...
                'CalcGy', true, 'CalcGp', true, 'Gmatrices_intermediate', true);

            t1 = sol.switches(1);
            t1Minus = t1 - eps(t1-eps(t1));
            sens = sensFun([t0, t1Minus, t1, tEnd]);
            Gy = {sens.Gy};
            Gp = {sens.Gp};
            [Gy1, Gp1, Uy1, Up1, Gy2, Gp2] = testCase.getSensitivitiesForJumpSensitivityRHS(sol, p);

            % MODEL 1
            testCase.verifyEqual(Gy{2}, Gy1(t1Minus), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{2}, Gp1(t1Minus), 'AbsTol', atol1);
            testCase.verifyEqual(Gy{3}, Uy1 * Gy1(t1Minus), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{3}, Uy1 * Gp1(t1Minus) + Up1, 'AbsTol', atol2);

            % MODEL 2
            testCase.verifyEqual(Gy{4}, Gy2(tEnd) * Uy1 * Gy1(t1Minus), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{4}, Gy2(tEnd) * (Uy1 * Gp1(t1Minus) + Up1) + Gp2(tEnd), 'AbsTol', atol2);
        end
        function testSensitivitiesSimpleEND_piecewise(testCase)
            % Test sensitivity computation across jumps using the simple, one-dimensional jumpSensitivityRHS.
            [integrator, options, t0, tEnd, p, x0] = testCase.getOdeDataForJumpSensitivityRHS();
            datahandle = prepareDatahandleForIntegration( ...
                'jumpSensitivityRHS', ...
                'solver', func2str(integrator), ...
                'options', options);
            sol = solveODE(datahandle, [t0 tEnd], x0, p);
            testCase.verifyEqual(length(sol.switches), 1);

            atol1 = 1e-5; % one OOM worse than with VDE
            atol2 = 1e-5;

            FDstep = generateFDstep(size(sol.y,1), length(p));
            sensFun = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_piecewise', ...
                'CalcGy', true, 'CalcGp', true, 'Gmatrices_intermediate', true);

            t1 = sol.switches(1);
            t1Minus = t1 - eps(t1-eps(t1));
            sens = sensFun([t0, t1Minus, t1, tEnd]);
            Gy = {sens.Gy};
            Gp = {sens.Gp};
            [Gy1, Gp1, Uy1, Up1, Gy2, Gp2] = testCase.getSensitivitiesForJumpSensitivityRHS(sol, p);

            % MODEL 1
            % Sensitivities before and after the first switch
            testCase.verifyEqual(Gy{2}, Gy1(t1Minus), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{2}, Gp1(t1Minus), 'AbsTol', atol1);
            testCase.verifyEqual(Gy{3}, Uy1 * Gy1(t1Minus), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{3}, Uy1 * Gp1(t1Minus) + Up1, 'AbsTol', atol2);

            % MODEL 2
            testCase.verifyEqual(Gy{4}, Gy2(tEnd) * Uy1 * Gy1(t1Minus), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{4}, Gy2(tEnd) * (Uy1 * Gp1(t1Minus) + Up1) + Gp2(tEnd), 'AbsTol', atol2);
        end
        function testSensitivitiesSimpleEND_full(testCase)
            % Test sensitivity computation across jumps using the simple, one-dimensional jumpSensitivityRHS.
            [integrator, options, t0, tEnd, p, x0] = testCase.getOdeDataForJumpSensitivityRHS();
            datahandle = prepareDatahandleForIntegration( ...
                'jumpSensitivityRHS', ...
                'solver', func2str(integrator), ...
                'options', options);
            sol = solveODE(datahandle, [t0 tEnd], x0, p);
            testCase.verifyEqual(length(sol.switches), 1);

            atol1 = 1e-5;
            atol2 = 1e-5;

            FDstep = generateFDstep(size(sol.y,1), length(p));
            sensFun = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_full', ...
                'CalcGy', true, 'CalcGp', true, 'Gmatrices_intermediate', true);

            t1 = sol.switches(1);
            % Since END fails around switches, we need to go a little further away to test our sensitivities. We will
            % still use the more precise t1Minus and t1Plus for computing the analytic sensitivities
            t1MinusMinus = t1 - 1e-3*t1;
            t1PlusPlus = t1 + 1e-3*t1;
            sens = sensFun([t0, t1MinusMinus, t1PlusPlus, tEnd]);
            Gy = {sens.Gy};
            Gp = {sens.Gp};
            [Gy1, Gp1, Uy1, Up1, Gy2, Gp2] = testCase.getSensitivitiesForJumpSensitivityRHS(sol, p);

            % MODEL 1
            testCase.verifyEqual(Gy{2}, Gy1(t1MinusMinus), 'AbsTol', atol1);
            testCase.verifyEqual(Gp{2}, Gp1(t1MinusMinus), 'AbsTol', atol1);

            % MODEL 2
            t1Minus = t1 - eps(t1-eps(t1));
            testCase.verifyEqual(Gy{3}, Gy2(t1PlusPlus) * Uy1 * Gy1(t1Minus), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{3}, Gy2(t1PlusPlus) * (Uy1 * Gp1(t1Minus) + Up1) + Gp2(t1PlusPlus), 'AbsTol', atol2);
            testCase.verifyEqual(Gy{4}, Gy2(tEnd) * Uy1 * Gy1(t1Minus), 'AbsTol', atol2);
            testCase.verifyEqual(Gp{4}, Gy2(tEnd) * (Uy1 * Gp1(t1Minus) + Up1) + Gp2(tEnd), 'AbsTol', atol2);
        end
    end
    methods
        function [integrator, options, t0, tEnd, p, x0] = getOdeDataForJumpSensitivityRHS(~)
            integrator = TestStateJumps.defaultIntegrator;
            options    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
            t0 = 0;
            tEnd = 10;
            p = 1/4;
            x0 = 1;
        end
        function [Gy1, Gp1, Uy1, Up1, Gy2, Gp2] = getSensitivitiesForJumpSensitivityRHS(~, sol, p)
            t0 = sol.x(1);
            x0 = sol.y(1);

            t1 = sol.switches(1);
            t1Minus = t1 - eps(t1-eps(t1));
            t1Plus = t1 + eps(t1);
            x1Minus1 = deval(sol, t1Minus);
            x1Plus1  = deval(sol, t1Plus);

            Gy1 = @(t) exp(p*(t-t0));
            Gp1 = @(t) (t-t0) * x0 * exp(p*(t-t0));
            Uy1 = 2 + (1/(2*x1Plus1) - 2*p*x1Minus1) * (t1 / (x1Minus1 + t1*p*x1Minus1));
            Up1 = (1/(2*x1Plus1) - 2*p*x1Minus1) / (p*p*(x1Minus1 + t1*p*x1Minus1));
            Gy2 = @(t) sqrt((t1 - t1 + x1Plus1^2) / (t + -t1 + x1Plus1^2));
            Gp2 = @(t) 0;
        end
        function expectedSwitches = bounceballSwitches(~, numSwitches, v0, g, gamma)
            % Compute the first n (numSwitches) switching points expected in the bouncing ball problem.
            % In the exact version, switch #i is computed as (2*v0/g)*(1 + gamma + ... + gamma^(i-1))
            expectedSwitches = zeros(1, numSwitches);
            firstBounce = (2*v0/g);
            gamma_eps = sqrt(1+2*eps)*gamma;
            swp = firstBounce;
            expectedSwitches(1) = swp;
            for i=2:numSwitches
                swp = swp*gamma_eps + firstBounce;
                expectedSwitches(i) = swp;
            end
        end
        function [Gy_t2_ts1, Gp_t2_ts1, Uy_t2, Up_t2] = bounceballIntermediateSensitivities( ...
                ~, sol, p, t1, t2Minus)
            % To help in computing sensitivities for the bouncing ball example, this function
            % provides intermediate matrices: given a previous switching point t1 and a left-shifted
            % next SWP t2Minus (just shy of the actual SWP, since our solutions are cadlag), get
            % the intermediate Gy and Gp between them (no updates) and the update matrices Uy and Up at ts2.
            % You can then piece them together with the cumulative G matrices from previous SWPs.
            g     = p(1);
            gamma = p(2);
            Gy_t_ts = @(t, ts) [1 t-ts; 0 1];
            Gp_t_ts = @(t, ts) [-(1/2)*(t-ts)^2 0; -(t-ts) 0];
            % Note: these matrices generally need x+(t_s), but we already reduced it to x- here.
            Uy   = @(t) [
                2*eps(1)*gamma^2-gamma,    (2/g)*eps(1)*gamma^2*deval(sol, t, 2);
                -(1+gamma)*g/deval(sol, t, 2), -gamma
                ];
            Up   = @(t) [
                eps(1)*gamma^2*deval(sol, t, 2)^2/(g^2), 2*eps(1)*gamma*deval(sol, t, 2)/g;
                0, -deval(sol, t, 2)
                ];
            Gy_t2_ts1 = Gy_t_ts(t2Minus, t1);
            Gp_t2_ts1 = Gp_t_ts(t2Minus, t1);
            Uy_t2 = Uy(t2Minus);
            Up_t2 = Up(t2Minus);
        end
    end
end