classdef TestSolverCompatibility < matlab.unittest.TestCase
    % Test that IFDIFF works with all of MATLAB's ODE solvers.

    properties (Constant)
        % Canonical example: input params and expected results. The latter are those obtained from IFDIFF
        % with ode45. So it's less of a correctness check and more just making sure that IFDIFF works
        % equally well with all solvers
        canonex_tspan = [0 20];
        canonex_x0 = [1;0];
        canonex_p = 5.437;
        canonex_rhsFunction = 'canonicalExampleRHS';
        canonex_odeoptions = odeset('AbsTol', 1e-12, 'RelTol', 1e-10);
        canonex_xEnd = [49.255067; 1.348824];
        canonex_SWPs = [11.000275475 11.27004032];

        subway_tspan = [0 65];
        subway_x0 = [0; 0; 0];
        % subway_p initialized later because we need to initPaths() before
        subway_rhsFunction = 'newYorkCitySubwayModelRhs';
        subway_odeoptions = odeset( 'AbsTol', 1e-20, 'RelTol', 1e-10);
        subway_xEnd = [2112.07361577; 0.00124794; 4124.77885608];
        subway_SWPs = [0.63166061, 2.43955402, 3.64338000, 5.60010643, 12.60705000, 45.78275000, 57.16005000];
    end
    properties (Access = private)
        % For a given problem, these four parameters need to be set appropriately (see setCanonexParameters for example)
        tspan
        x0
        p
        rhsFunction
        odeoptions
        expected_xEnd
        expected_SWPs

        subway_p
    end

    methods (TestClassSetup)
        function setup(testCase)
            % is this a terrible hack or ok?
            cd("..");
            initPaths();
            testCase.subway_p = nysscc_getPhysicsParameters();
            tic
        end
    end
    
    methods (TestClassTeardown)
        function teardown(~)
            toc
        end
    end

    methods (TestMethodSetup)
    end

    methods (Test)
        function testOde23Canonex(testCase)
            setCanonexParameters(testCase);
            [~, sol] = solveWith(testCase, @ode23);

            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-5);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end
        function testOde23Subway(testCase)
            setSubwayParameters(testCase);
            [~, sol] = solveWith(testCase, @ode23);

            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-5);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end

        function testOde45Canonex(testCase)
            setCanonexParameters(testCase);;
            [~, sol] = solveWith(testCase, @ode45);

            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-5);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end
        function testOde45Subway(testCase)
            setSubwayParameters(testCase);
            [~, sol] = solveWith(testCase, @ode45);

            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-5);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end

        % ode78 suffers from the same problem as ode89 (see below). In
        % this particular test case, it _happens_ to work anyway.
        function testOde78Canonex(testCase)
            setCanonexParameters(testCase);
            [~, sol] = solveWith(testCase, @ode78);

            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-5);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end
        function testOde78Subway(testCase)
            setSubwayParameters(testCase);
            [~, sol] = solveWith(testCase, @ode78);

            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-5);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end

        % ode89's continuous extension unfortunately causes the last time
        % point computed to be t + 0.487*h, which leads to switch_cond
        % having the wrong value, leading to a crash in the next step.
        function testOde89Canonex(testCase)
            setCanonexParameters(testCase);
            [~, sol] = solveWith(testCase, @ode89);

            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-5);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end
        function testOde89Subway(testCase)
            setSubwayParameters(testCase);
            [~, sol] = solveWith(testCase, @ode89);

            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-5);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end

        function testOde15sCanonex(testCase)
            setCanonexParameters(testCase);
            [~, sol] = solveWith(testCase, @ode15s);

            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-5);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end
        function testOde15sSubway(testCase)
            setSubwayParameters(testCase);
            [~, sol] = solveWith(testCase, @ode15s);

            % This solver is not so accurate it seems, have to use one order of magnitude larger AbsTol.
            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-4);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end

        function testOde113Canonex(testCase)
            setCanonexParameters(testCase);
            [~, sol] = solveWith(testCase, @ode113);

            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-5);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end
        function testOde113Subway(testCase)
            setSubwayParameters(testCase);
            [~, sol] = solveWith(testCase, @ode113);

            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-5);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end

        function testOde23tCanonex(testCase)
            setCanonexParameters(testCase);
            [~, sol] = solveWith(testCase, @ode23t);

            % Using higher tolerance. The docs say that this solver is
            % good for "crude tolerances", so I figure this is normal.
            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-5);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end
        function testOde23tSubway(testCase)
            setSubwayParameters(testCase);
            [~, sol] = solveWith(testCase, @ode23t);

            % Using higher tolerance. The docs say that this solver is
            % good for "crude tolerances", so I figure this is normal.
            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-3);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end

        function testOde23tbCanonex(testCase)
            setCanonexParameters(testCase);
            [~, sol] = solveWith(testCase, @ode23tb);

            % Using higher tolerance. The docs say that this solver is
            % good for "crude tolerances", so I figure this is normal.
            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-5);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end
        function testOde23tbSubway(testCase)
            setSubwayParameters(testCase);
            [~, sol] = solveWith(testCase, @ode23tb);

            % Using higher tolerance. The docs say that this solver is
            % good for "crude tolerances", so I figure this is normal.
            testCase.verifyEqual(sol.y(:,end), testCase.expected_xEnd, "RelTol", 1e-3);
            testCase.verifyEqual(sol.switches, testCase.expected_SWPs, "RelTol", 1e-5);
        end

    end

    methods (Access = private)
        function testCase = setCanonexParameters(testCase)
            testCase.tspan = testCase.canonex_tspan;
            testCase.x0 = testCase.canonex_x0;
            testCase.p = testCase.canonex_p;
            testCase.rhsFunction = testCase.canonex_rhsFunction;
            testCase.odeoptions = testCase.canonex_odeoptions;
            testCase.expected_xEnd = testCase.canonex_xEnd;
            testCase.expected_SWPs = testCase.canonex_SWPs;
        end
        function testCase = setSubwayParameters(testCase)
            testCase.tspan = testCase.subway_tspan;
            testCase.x0 = testCase.subway_x0;
            testCase.p = testCase.subway_p;
            testCase.rhsFunction = testCase.subway_rhsFunction;
            testCase.odeoptions = testCase.subway_odeoptions;
            testCase.expected_xEnd = testCase.subway_xEnd;
            testCase.expected_SWPs = testCase.subway_SWPs;
        end
        function [data, sol] = solveWith(testCase, integrator)
            datahandle = prepareDatahandleForIntegration( ...
                testCase.rhsFunction, ...
                'solver', ...
                func2str(integrator), ...
                'options', ...
                testCase.odeoptions ...
            );
            sol = solveODE(datahandle, testCase.tspan, testCase.x0, testCase.p);
            data = datahandle.getData();
        end
    end
end