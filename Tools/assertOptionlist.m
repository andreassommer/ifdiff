function answer = assertOptionlist(object)
   % assertOptionlist(object);
   %
   % Asserts that the given object is an optionlist and returns true.
   % Otherwise, an error is thrown.
   %
   % INPUT:     object  -  object to be checked
   %
   % OUTPUT:    answer  -  true if object is a valid optionlist.
   %
   % Copyright (c) 2016, Andreas Sommer
   % andreas.sommer@iwr.uni-heidelberg.de
   % mail@andreas-sommer.eu
   
   % ensure optionlist is an optionlist
   [passed, problem] = isOptionlist(object);
   if ~passed
      error('Not a valid optionlist! Problem: %s', problem);
   end
   
   % no error, so it's an optionlist
   answer = true;
end