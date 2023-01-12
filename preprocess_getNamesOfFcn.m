function [fnames, rhs_path] =  preprocess_getNamesOfFcn(filename)
% Function to get all names of function that are used in the function in
% filename.
% This function is important to implement the function_index. 
% 
% INPUT: filename, name of a function
% OUTPUT: fnames, cell array with a characterstring in each;
% rhs_path: path of the rhs 


% get List of all paths that are required when filename.m is executed
[fList,~] = matlab.codetools.requiredFilesAndProducts([filename, '.m']);


% check if there are any functions 
l = length(fList);
fnames = cell(3,l-1);  % preallocate, 2nd for new name, 3rd row is for mtreeplus object
if l == 1
    fnames = {};
end

% map through all paths; rhs_path is here included and we need special care for it
i = 1; 
for k = 1:l
    % extract filename from path
    [a, z, ~] = fileparts(fList{k});
    
    % search for the original rhs filename 
    condition = ~strcmp( z, filename); % do not save path of filename here
    if condition
        fnames{1,i} = z;
        i = i + 1; 
    else
        rhs_path = a;        % but here
    end
end




end