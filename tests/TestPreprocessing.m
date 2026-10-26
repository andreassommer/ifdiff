classdef TestPreprocessing < matlab.unittest.TestCase
    %TESTPREPROCESSING
    %
    %Test preprocessing mechanism. (Manual review required)

    properties (TestParameter)
        % Variants of the example from the issue on nested functions, which all have the same solution.
        rhsNested = { ...
            @testPreprocNestedIssue, ... % Original example from the issue
            @testPreprocNestedRead, ... % Nested functions read variables of the enclosing function
            @testPreprocNestedIf, ... % Variable read by nested functions is only assigned within an if block
            @testPreprocNestedUpdate, ... % Variable read by nested functions changes between calls
            @testPreprocNestedWrite, ... % Nested function writes a variable of the enclosing function
            @testPreprocNestedHelperRHS}; % Nested functions in a helper function
    end

    methods (TestClassSetup)
        function setPath(testCase)
            import matlab.unittest.fixtures.PathFixture

            testCase.applyFixture(PathFixture('data/TestPreprocessing'));
        end
    end

    methods(Test)
        function allSpecialCases(~)
            %ALLSPECIALCASES    Includes all language constructs treated in a special way by IFDIFF.
            %   No error is considered a success.
            %   Mostly meant for manual review of the generated preprocessed files.
            prepareDatahandleForIntegration('testPreprocessingRHS');
        end

        function testIgnoredFunctions(testCase)
            % RHS containing ignored function, which should not be preprocessed and kept in switching/jump functions

            tspan = [0, 2];
            y0 = 0;
            p = [];

            % Setup config to explicitly ignore a helper function.
            configNew = makeConfig();
            configNew.functionIgnoreList{end+1} = func2str(@testPreprocessingIgnoredFunctionsHelper);
            try
                configOld = makeConfig(configNew);
                datahandle = prepareDatahandleForIntegration(@testPreprocessingIgnoredFunctions);
                solve = @() solveODE(datahandle, tspan, y0, p);
                % Suppress command window output in RHS.
                [~, sol] = evalc('solve()');
            catch exception
                makeConfig(configOld);
                rethrow(exception);
            end
            makeConfig(configOld);

            % Check that switching function still produces command window output.
            switchingFunction = sol.switchingFunction{1};
            [output, ~] = evalc('switchingFunction([], 0, 0, [])');
            testCase.verifyNotEmpty(output);
            testCase.verifyEqual(deval(sol, tspan(end)), 1, 'AbsTol', 1e-14)
        end

        function testNestedFunctions(testCase, rhsNested)
            % RHS containing nested functions without switches (directly or in a helper function).
            % Preprocessing has to warn about the nested functions. Since they may read and write variables of the
            % enclosing function, all code has to be kept in switching functions.

            [tspan, x0, p] = issueExampleSetup();

            datahandle = testCase.verifyWarning(@() prepareDatahandleForIntegration(rhsNested), ...
                'IFDIFF:Preprocessing:NestedFunction');
            sol = testCase.verifyWarningFree(@() solveODE(datahandle, tspan, x0, p));

            [switches, xEnd] = issueExampleSolution(tspan, p);
            testCase.verifyEqual(sol.switches, switches, 'AbsTol', 1e-8);
            testCase.verifyEqual(deval(sol, tspan(end)), xEnd, 'AbsTol', 1e-6);
        end

        function testLocalFunctions(testCase)
            % RHS containing local functions, which should not trigger the nested function warning.

            [tspan, x0, p] = issueExampleSetup();

            datahandle = testCase.verifyWarningFree(@() prepareDatahandleForIntegration(@testPreprocLocalFcn));
            sol = testCase.verifyWarningFree(@() solveODE(datahandle, tspan, x0, p));

            [switches, xEnd] = issueExampleSolution(tspan, p);
            testCase.verifyEqual(sol.switches, switches, 'AbsTol', 1e-8);
            testCase.verifyEqual(deval(sol, tspan(end)), xEnd, 'AbsTol', 1e-6);
        end
    end
end


function [tspan, x0, p] = issueExampleSetup()
% Time span, initial values and parameters for the example from the issue on nested functions.
tspan = [0, 30];
x0 = [0; 1000];
p = [0.75, 0.25];
end


function [switches, xEnd] = issueExampleSolution(tspan, p)
% Analytic solution of the example from the issue on nested functions with x0 = [0; 1000].
% Between the switches, the RHS is polynomial in t, so the solution can be computed exactly with polynomials:
%   phase 1 (x1 <= 750):       x1' = q1(t),                              x2' = 0
%   phase 2 (750 < x1 <= 800): x1' = q1(t) - (1000 - x2)*(p1*(t-19)+p2), x2' = -300
%   phase 3 (x1 > 800):        x1' = q1(t) - (1000 - x2)*(p1*(t-19)+p2), x2' = 0
q1 = [50/27, -100/3, 400/3];
rate = [p(1), p(2) - 19*p(1)]; % p1*(t-19)+p2

% Phase 1: x1(t) = int_0^t q1, x2 = 1000
x1 = polyint(q1);
t1 = firstRoot(x1 - [0, 0, 0, 750], tspan(1));

% Phase 2: x2(t) = 1000 - 300*(t - t1)
x1 = polyint(polyAdd(q1, -conv(300*[1, -t1], rate)));
x1(end) = 750 - polyval(x1, t1);
t2 = firstRoot(x1 - [0, 0, 0, 800], t1);
x2 = 1000 - 300*(t2 - t1);

% Phase 3: x2 constant
x1 = polyint(polyAdd(q1, -(1000 - x2)*rate));
x1(end) = 800 - polyval(x1, t2);

switches = [t1, t2];
xEnd = [polyval(x1, tspan(end)); x2];
end


function t = firstRoot(poly, tStart)
% First real root of a polynomial after tStart.
r = roots(poly);
r = real(r(abs(imag(r)) < 1e-12 & real(r) > tStart));
t = min(r);
end


function c = polyAdd(a, b)
% Add two polynomials of possibly different degree.
n = max(length(a), length(b));
c = [zeros(1, n - length(a)), a] + [zeros(1, n - length(b)), b];
end
