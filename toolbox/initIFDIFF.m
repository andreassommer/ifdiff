function initIFDIFF()
% initIFDIFF()
%
% Initializes IFDIFF, setting up paths.
%
% INPUT:    none
%
% OUTPUT:   none
%
%
% Andreas Sommer, Jul2025
% code@andreas-sommer.eu
%


% receive the required paths
ifdiffpaths = generateIFDIFFpaths();

% add them to the search path at the beginning (search them first)
addpath(ifdiffpaths, '-begin');

% Now that the paths are set, the mtreeplus class should be accessible.
if ~exist('mtreeplus', 'class')
    disp('Warning: mtreeplus class required for IFDIFF not found in toolbox directory.')
    answer = input('Attempt to generate new mtreeplus class? [y/n]: ', 's');
    if strcmpi(answer, 'y')
        disp('Running make_mtreeplus script to generate new mtreeplus class.')
        run_make_mtreeplus();
    else
        msg = [
            'Not generating new mtreeplus class.\n' ...
            'Make sure to provide an mtreeplus class before using IFDIFF, ' ...
            'e.g. by running the make_mtreeplus script in the toolbox directory.\n' ...
            ];
        fprintf(msg)
    end
end
end

%% Helpers
% make_mtreeplus script has to be called from the toolbox folder.
function run_make_mtreeplus()
dirOld = pwd();
restoreDir = onCleanup(@() cd(dirOld));

[dirToolbox, ~, ~] = fileparts(mfilename('fullpath'));
cd(dirToolbox)
make_mtreeplus;
end
