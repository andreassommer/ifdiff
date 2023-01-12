function clearPaths()
   % function clearPaths()
   % 
   % Remove all extra added paths from search path
   % 
   % INPUT:  none
   % OUTPUT: none
   %

   rmpath('./Tools');
   rmpath(genpath('./Examples'));  % include subdirs

end