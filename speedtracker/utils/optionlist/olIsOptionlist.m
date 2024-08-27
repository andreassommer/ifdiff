function [answer, problem] = olIsOptionlist(object)
   % [answer, problem] = olIsOptionlist(optionlist)
   %
   % Checks if object is a valid optionlist, i.e. consists of key-value-pairs.
   %
   % INPUT:    object --> object to be checked
   %
   % OUTPUT:   answer --> TRUE if object is an optionlist, FALSE otherwise
   %          problem --> string telling which test failed
   %
   %
   % Author:  Andreas Sommer, 2016, 2024
   % andreas.sommer@iwr.uni-heidelberg.de
   % code@andreas-sommer.eu
   %
   % History:     Jul2024 --> renamed to ol* scheme


   % Init
   answer = false;

   % ensure object is a cell array
   if ~(iscell(object))
      if (nargout > 1)
         problem = sprintf('Object is not an optionlist, but a %s.', class(object));
      end
      return
   end

   % ensure length of object is even
   if ~(mod(length(object),2)==0)
      if (nargout > 1)
         problem = sprintf('Invalid length of %d detected, but must be even!', length(object));
      end
      return
   end

   % walk through keys and check if they are strings
   for k = 1:2:length(object)
      key = object{k};
      if ~ischar(key)
         if (nargout > 1)
            problem = sprintf('Element #%d is not a string, but a %s.', k, class(key));
         end
         return
      end
   end

   % all tests passed, so it seems to be an optionlist
   answer = true;
   problem = '';
   return

end