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


end % of function
