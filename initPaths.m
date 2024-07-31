function initPaths()
   % function initPaths()
   % 
   % Initialise the paths for ifdiff.
   % 
   % INPUT:   none
   % OUTPUT:  none
   %
   addpath('./');
   addpath(genpath('./Tools'));
   addpath(genpath('./Examples'));  % include subdirs
   addpath(genpath('./PreprocessedFunctions'))
   addpath('./ComputeSensitivities');
end
