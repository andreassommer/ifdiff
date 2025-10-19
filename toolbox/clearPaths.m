function clearPaths()
%CLEARPATHS Remove directories required by IFDIFF from the MATLAB search path.
%
%   INPUT
%   [none]
%
%   OUTPUT
%   [none]
%
%   See also initIFDIFF whose paths additions are undone by CLEARPATHS.


% receive the required paths
ifdiffpaths = generateIFDIFFpaths();

% remove them from the search path
rmpath(ifdiffpaths);


end
