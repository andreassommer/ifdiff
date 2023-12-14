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
preprocessed.rhs = cell(4,1);

% original filename
preprocessed.rhs{1,1} = filename; 

% new name of rhs
preprocessed.rhs{2,1} = [config.preprocess.rhs_name_prefix, filename]; 

% check mtree for comments to ignore mtree and store tree, flag, and
% possibly stings of mtree
[tree, flag, varargout] = check_mtree(filename);
preprocessed.rhs{3,1} = tree;
preprocessed.rhs{4,1} = flag;
if flag
    preprocessed.rhs{end+1,1} = varargout;
end

% get all paths that are required to execute filename.m (we want to
% identify all functions that are being called within the rhs) 
[preprocessed.fcn, preprocessed.rhs_path] = preprocess_getNamesOfFcn(filename); 


% most of the magic is done here: transform the rhs and the functions that are called within rhs
preprocessed = preprocess_rhs(preprocessed);

% check if there is a ctrlif; otherwise solveODE will fail (empty signature)
preprocess_rhs_checkForCtrlif(preprocessed)






end 