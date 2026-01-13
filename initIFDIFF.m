function initIFDIFF()
%INITIFDIFF
%
%Wrapper for the actual initIFDIFF function, so that it can be called from the project root,
%i.e. without first navigating to the toolbox subdirectory.

dirOld = pwd();
restoreDir = onCleanup(@() cd(dirOld));
% Change to toolbox directory.
[dirRoot, ~, ~] = fileparts(mfilename('fullpath'));
dirToolbox = fullfile(dirRoot, 'toolbox');
cd(dirToolbox);
% Note: This does not/should not call this function.
% Instead the actual initIFDIFF function in the toolbox subdirectory will be called,
% since functions in working directory have precedence over functions on MATLAB path.
initIFDIFF();
end
