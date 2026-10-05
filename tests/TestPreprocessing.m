classdef TestPreprocessing < matlab.unittest.TestCase
    %TESTPREPROCESSING
    %
    %Test preprocessing mechanism. (Manual review required)

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

        function dispInRhs(testCase)
            %DISPINRHS
            %
            %Functions with side effects (e.g. disp, fprintf) should remain untouched in generated functions.
            tspan = [0, 2];
            y0 = 0;
            p = [];

            datahandle = prepareDatahandleForIntegration(@testPreprocessingDispRHS);
            solve = @() solveODE(datahandle, tspan, y0, p);

            % Suppress command window output in RHS.
            [~, sol] = evalc('solve()');
            % Check that switching function still produces command window output.
            switchingFunction = sol.switchingFunction{1};
            [output, ~] = evalc('switchingFunction([], 0, 0, [])');
            testCase.verifyNotEmpty(output);
            testCase.verifyEqual(deval(sol, tspan(end)), 1, 'AbsTol', 1e-14)
        end
    end
end
