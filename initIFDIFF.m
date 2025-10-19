function initIFDIFF()
%INITIFDIFF
%
%Wrapper for the actual initIFDIFF function, so that it can be called from the project root,
%i.e. without first navigating to the toolbox subfolder.

oldPwd = pwd();
clPwd = onCleanup(@() cd(oldPwd));

[dirRoot, ~, ~] = fileparts(mfilename('fullpath'));
% Make sure root directory is not in the path yet, so we call the initIFDIFF function in toolbox subfolder.
callWithoutWarning(@() rmpath(dirRoot), 'MATLAB:rmpath:DirNotFound');
% Change to toolbox subfolder.
dirToolbox = fullfile(dirRoot, 'toolbox');
cd(dirToolbox);

% Warning: This does not/should not call this function.
% Instead the actual initIFDIFF function in the toolbox subfolder will be called.
initIFDIFF();
end

function callWithoutWarning(func, warnId)
w = warning('query', warnId); % Get current state of warning
warning('off', warnId);
try
    func();
catch ME
    warning(w.state, warnId); % Restore
end
warning(w.state, warnId); % Restore
end
