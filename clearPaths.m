function clearPaths()
%CLEARPATHS Remove directories required by IFDIFF from the MATLAB search path.
%
%   INPUT
%   [none]
%
%   OUTPUT
%   [none]
%
%   See also INITPATHS whose changes are undone by CLEARPATHS.


% Get absolute path to directory in which this file resides.
[filePath, ~, ~] = fileparts(mfilename('fullpath'));

rmpath(filePath);
rmpath(genpath(fullfile(filePath, 'Tools')));
rmpath(genpath(fullfile(filePath, 'Examples')));
rmpath(genpath(fullfile(filePath, 'PreprocessedFunctions')));
rmpath(fullfile(filePath, 'ComputeSensitivities'));
end