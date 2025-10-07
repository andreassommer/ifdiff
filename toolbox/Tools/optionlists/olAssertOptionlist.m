function answer = olAssertOptionlist(object)
   % olAssertOptionlist(object);
   %
   % Asserts that the given object is an optionlist and returns true.
   % Otherwise, an error is thrown.
   %
   % INPUT:     object  -  object to be checked
   %
   % OUTPUT:    answer  -  true if object is a valid optionlist.
   %
   % Author:  Andreas Sommer, 2016
   % andreas.sommer@iwr.uni-heidelberg.de
   % code@andreas-sommer.eu
   %
   % History:     Jul2024 --> renamed to ol* scheme
   
   % ensure optionlist is an optionlist
   [passed, problem] = olIsOptionlist(object);
   if ~passed
      error('Not a valid optionlist! Problem: %s', problem);
   end
   
   % no error, so it's an optionlist
   answer = true;
end