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
            t0 = 0;
            tF = 10;
            x0    = 0;
            p     = 0;
            
            datahandle = prepareDatahandleForIntegration('simpleIgnoreRHS', ...
                'solver', func2str(solver), ...
                'options', options);
            data = datahandle.getData();
            % ensure only one of the two ifs got turned into a ctrlif
            rIndex_preprocessed = mtree_rIndex(data.mtreeplus{3,1});
            testCase.verifyEqual(length(rIndex_preprocessed.BODY.ctrlif), 1);

            % ensure the ctrlif did not lead to a switching event
            sol = solveODE(datahandle, [t0 tF], x0, p);
            testCase.verifyEqual(length(sol.switches), 0);
            testCase.verifyEqual(deval(sol, tF), 15, 'RelTol', 0.1);
        end
        function testIgnoreNested(testCase)
            options = odeset();
            solver = @ode45;
            t0 = 0;
            tF = 10;
            x0    = 0;
            p     = 0;
            
            datahandle = prepareDatahandleForIntegration('nestedIgnoreRHS', ...
                'solver', func2str(solver), ...
                'options', options);
            data = datahandle.getData();
            % ensure only one of the two ifs got turned into a ctrlif
            rIndex_preprocessed = mtree_rIndex(data.mtreeplus{3,1});
            testCase.verifyEqual(length(rIndex_preprocessed.BODY.ctrlif), 1);

            % ensure the ctrlif did not lead to a switching event
            sol = solveODE(datahandle, [t0 tF], x0, p);
            testCase.verifyEqual(length(sol.switches), 0);
            testCase.verifyEqual(deval(sol, tF), 18, 'RelTol', 0.1);
        end
        function testIgnoredIfInNonIgnoredIf(testCase)
            options = odeset();
            solver = @ode45;
            t0 = 0;
            tF = 10;
            x0    = 0;
            p     = 0;
            
            datahandle = prepareDatahandleForIntegration('ignoredIfInNonIgnoredIfRHS', ...
                'solver', func2str(solver), ...
                'options', options);
            data = datahandle.getData();
            % ensure only the outer if got turned into a ctrlif
            rIndex_preprocessed = mtree_rIndex(data.mtreeplus{3,1});
            testCase.verifyEqual(length(rIndex_preprocessed.BODY.ctrlif), 1);

            sol = solveODE(datahandle, [t0 tF], x0, p);
            testCase.verifyEqual(length(sol.switches), 1);
            testCase.verifyEqual(sol.switches(1), 5, 'RelTol', 1e-6);
            testCase.verifyEqual(deval(sol, tF), 18, 'RelTol', 0.1);
        end
    end
    
end