function [pathStr, pathList] = generateIFDIFFpaths()
% [pathStr, pathList] = generateIFDIFFpaths()
%
% Generates a character array with all paths for IFDIFF.
% The character array can be passed to addpath or rmpath
%
% INPUT:    none
%
% OUTPUT:   pathStr --> character array with paths needed/used by IFDIFF
%          pathList --> cell array of sub-paths
%           
%
% Andreas Sommer, Jul2025
% code@andreas-sommer.eu
%


% get directory this file resides in
[selfdir, ~] = fileparts(mfilename('fullpath'));

% list all IFDIFF pars
pathList = { selfdir  ... % main directory of IFDIFF
           , genpath(fullfile(selfdir, 'Tools'))                           ...
           , genpath(fullfile(selfdir, 'Examples'))                        ...
           , genpath(fullfile(selfdir, 'PreprocessedFunctions'))           ...
           ,         fullfile(selfdir, 'ComputeSensitivities')             ... % no subdirs
           , genpath(fullfile(selfdir, 'GenerateFixedBranchingFunctions')) ...
           };

% combine them into a single path specification
pathStr = strjoin(pathList, pathsep());

% finito
end

