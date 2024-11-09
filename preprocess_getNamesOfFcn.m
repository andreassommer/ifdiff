function [fnames, rhs_path] =  preprocess_getNamesOfFcn(rhs_name)
% Function to get all names of function that are used in the function in rhs_name.
% INPUT: rhs_name, name of a function
% OUTPUT: fnames, cellstring of helper functions' names (does not include rhs_name itself);
% rhs_path: path of rhs_name


% get list of all paths that are required when rhs_name.m is executed
[fList,~] = matlab.codetools.requiredFilesAndProducts([rhs_name, '.m']);


% check if there are any helper functions
l = length(fList);
fnames = cell(4,l-1);
if l == 1
    % there is only the RHS. We need its path, but fnames is only for helper functions, so it stays empty
    fnames = cell(4, 0);
end

i = 1; 
for k = 1:l
    [a, z, ~] = fileparts(fList{k});

    % if the function is the original rhs_name, save its path, which we will need later. If it is
    % a different function, save it in fnames.
    condition = ~strcmp( z, rhs_name);
    if condition
        fnames{1,i} = z;
        i = i + 1; 
    else
        rhs_path = a;
    end
end
end