function initPaths()
   % function initPaths()
   % 
   % Initialise the paths for ifdiff.
   % 
   % INPUT:   none
   % OUTPUT:  none
   %

   addpath('./Tools');
   addpath(genpath('./Examples'));  % include subdirs
   addpath(genpath('./PreprocessedFunctions'))
   addpath('./ComputeSensitivities');
   % addpath(genpath('./tinevez-matlab-tree-3d13d15'))
end
