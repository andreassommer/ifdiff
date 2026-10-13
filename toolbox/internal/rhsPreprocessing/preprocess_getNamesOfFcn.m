function [helperFunctions, rhsPath] =  preprocess_getNamesOfFcn(rhsName)
%preprocess_getNamesOfFcn - Get names of helper functions and RHS path
%
%    Syntax
%      [helperFunctions, rhsPath] =  preprocess_getNamesOfFcn(rhsName)
%
%    Input Arguments
%      rhsName - Name of the RHS function
%        char array
%
%    Output Arguments
%      helperFunctions - Contains helper function names in first row
%        4-by-n cell array of char array
%      rhsPath - Filepath to the directory containing the RHS function file
%        char array

config = makeConfig();

% Get list of all files required to run the RHS.
fList = matlab.codetools.requiredFilesAndProducts([rhsName, '.m']);
[paths, names] = fileparts(fList);

% Get RHS path.
idxRhs = strcmp(rhsName, names);
rhsPath = paths{idxRhs};
% Remove RHS and any explicitly ignored functions from helper function list.
idxIgnored = ismember(names, config.functionIgnoreList);
helperNames = names(~idxRhs & ~idxIgnored);
% Output array should have 4 rows, first row are the names.
helperFunctions = cell(4, length(helperNames));
helperFunctions(1, :) = helperNames;
end
