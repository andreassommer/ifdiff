function [pathStr, pathList] = generateIFDIFFpaths()
% [pathStr, pathList] = generateIFDIFFpaths()
%
% Generates a character array with all paths for IFDIFF.
% The character array can be passed to addpath or rmpath
%
% INPUT:    none
%
% OUTPUT:   pathStr --> character array with paths needed/used by IFDIFF
%           pathList --> cell array of sub-paths
%
%
% Andreas Sommer, Jul2025
% code@andreas-sommer.eu


% Get directory this file resides in, which should be the toolbox folder.
[selfdir, ~] = fileparts(mfilename('fullpath'));

% Collect IFDIFF subdirectories.
pathList = { ...
    selfdir, ...
    genpath(fullfile(selfdir, 'doc')), ...
    genpath(fullfile(selfdir, 'examples')), ...
    genpath(fullfile(selfdir, 'internal')), ...
    };

% Combine them into a single path specification.
pathStr = strjoin(pathList, pathsep());
end
