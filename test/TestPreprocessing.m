classdef TestPreprocessing < matlab.unittest.TestCase
    %TESTPREPROCESSING  Test class for IFDIFF's preprocessing mechanism. (Manual review required)
    methods(TestClassSetup)
        function setPath(testCase)
            originalPath = path;
            testCase.addTeardown(@path, originalPath);
            if ~exist('initPaths', 'file')
                % We are probably in the test directory, so check parent directory
                cd('..');
            end
            initPaths();
            addpath(fullfile('test', 'TestPreprocessing'));
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