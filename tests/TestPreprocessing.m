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
    end
end
