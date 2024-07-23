function preprocessed = preprocess(filename)
% preprocess rhs 
% add ctrlif 
% set ctrlif index and function index 
% part of prepareDatahandleForIntegration


% rhs = right hand side 

% get set of character strings
config = makeConfig(); 

% my way of storing mtree objects: 
% cell of 5x1: 
% 1: original filename; 
% 2; new filename (we don't want to be working with the original file of the user; 
% 3: mtreee object 
% later in switching point generation there will be 4-7 with additional information

 % preallocate 
preprocessed.rhs = cell(3,1);

% original filename
preprocessed.rhs{1,1} = filename; 

% new name of rhs
preprocessed.rhs{2,1} = [config.preprocessedRhsNamePrefix, filename];

% store mtree
preprocessed.rhs{3,1} = mtreeplus(strcat(filename, '.m'), '-file');


% get all paths that are required to execute filename.m (we want to
% identify all functions that are being called within the rhs) 
[preprocessed.fcn, preprocessed.rhs_path] = preprocess_getNamesOfFcn(filename); 


% most of the magic is done here: transform the rhs and the functions that are called within rhs
preprocessed = preprocess_rhs(preprocessed);

% check if there is a ctrlif; otherwise solveODE will fail (empty signature)
preprocess_rhs_checkForCtrlif(preprocessed)






end 