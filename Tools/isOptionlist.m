function [answer, problem] = isOptionlist(object)
   % [answer problem] = isOptionlist(optionlist)
   % 
   % Checksif object is a valid optionlist, i.e. consists of key-value-pairs.
   %
   % INPUT:    object --> object to be checked
   % 
   % OUTPUT:   answer --> TRUE if object is an optionlist, FALSE otherwise
   %          problem --> string telling which test failed
   %
   %
   % Copyright (c) 2016, Andreas Sommer
   % andreas.sommer@iwr.uni-heidelberg.de
   % mail@andreas-sommer.eu

   % Sep2016
   
   % Init
   answer = false;
      
   % ensure object is a cell array
   if ~(iscell(object))
      problem = sprintf('Object is not an optionlist, but a %s.', class(object));
      return
   end  
   
   % ensure length of object is even
   if ~(mod(length(object),2)==0) 
      problem = sprintf('Invalid length of %d detected, but must be even!', length(object));
      return
   end
   
   % walk through keys and check if they are strings
   for k = 1:2:length(object)
      key = object{k};
      if ~ischar(key)
         problem = sprintf('Element #%d is not a string, but a %s.', k, class(key));
         return
      end;
   end
   
   % all tests passed, so it seems to be an optionlist
   answer = true;
   problem = '';
   return
      
end