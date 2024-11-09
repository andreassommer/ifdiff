function preprocessed = preprocess(filename)
% preprocess rhs 
% add ctrlif 
% set ctrlif index and function index 
% part of prepareDatahandleForIntegration


% rhs = right hand side 

% get set of character strings
config = makeConfig(); 

% RHS data: original function name, name of preprocessed function, and syntax tree
preprocessed.rhs = cell(4,1);
preprocessed.rhs{1,1} = filename;
preprocessed.rhs{2,1} = [config.preprocessedRhsNamePrefix, filename];
preprocessed.rhs{3,1} = mtreeplus(strcat(filename, '.m'), '-file', '-comments');
preprocessed.rhs{4,1} = [mtree_getIgnoredIfs(preprocessed.rhs{3,1}) mtree_getJumpUpdateIgnores(preprocessed.rhs{3,1})];

% get all paths that are required to execute filename.m (we want to
% identify all functions that are being called within the rhs) 
[preprocessed.fcn, preprocessed.rhs_path] = preprocess_getNamesOfFcn(filename); 


% most of the magic is done here: transform the rhs and the functions that are called within rhs
preprocessed = preprocess_rhs(preprocessed);

% check if there is a ctrlif; otherwise solveODE will fail (empty signature)
preprocess_rhs_checkForCtrlif(preprocessed)






end 