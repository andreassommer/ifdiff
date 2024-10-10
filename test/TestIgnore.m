classdef TestIgnore < matlab.unittest.TestCase
    
    methods(TestClassSetup)
        function setPath(testCase)
            originalPath = path;
            testCase.addTeardown(@path, originalPath);

            if ~exist('initPaths', 'file')
                % We are probably in the test directory, so check parent directory
                cd('..');
            end
            initPaths();

            % Get absolute path to directory in which this file resides.
            [filePath, ~, ~] = fileparts(mfilename('fullpath'));
            addpath(fullfile(filePath, 'TestIgnore'));
        end
    end
    
    methods(Test)
        function testIgnoreSimple(testCase)
            options = odeset();
            solver = @ode45;
            tspan = [0 10];
            x0    = 0;
            p     = 0;
            
            datahandle = prepareDatahandleForIntegration('simpleIgnoreRHS', ...
                'solver', func2str(solver), ...
                'options', options);
            sol = solveODE(datahandle, tspan, x0, p);
            testCase.verifyEqual(length(sol.switches), 0);
        end
    end
    
end