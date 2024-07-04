function initPaths()
%INITPATHS  Add directories required by IFDIFF to the MATLAB search path.
%   You should always run this function before using IFDIFF (once per MATLAB session)!
%
%   INPUT
%   [none]
%
%   OUTPUT
%   [none]
%
%   See also CLEARPATHS to undo the changes made by INITPATHS.


% Get absolute path to directory in which this file resides.
[filePath, ~, ~] = fileparts(mfilename('fullpath'));

addpath(filePath);
addpath(genpath(fullfile(filePath, 'Tools')));
addpath(genpath(fullfile(filePath, 'Examples')));
addpath(genpath(fullfile(filePath, 'PreprocessedFunctions')));
addpath(fullfile(filePath, 'ComputeSensitivities'));
addpath(fullfile(filePath, 'signature'));
end
