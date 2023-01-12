function result = hasOption(cellarray, searchProperty)
   % function result = hasOption(cellarray, searchProperty)
   %
   % Checks, if the given cellarray contains a name/value pair
   % with given property name.
   %
   % Copyright (c) 2009,2010,2011, Andreas Sommer
   % andreas.sommer@iwr.uni-heidelberg.de
   % mail@andreas-sommer.eu

   % History: Sep2016 --> renamed to hasOption, asserting optionlist
   
   % initialize
   result = false;
   assertOptionlist(cellarray);
   

   % cycle through properties
   for k = 1:2:length(cellarray)
      propertyName = cellarray{k};
      if ~ischar(propertyName),
         result = NaN;
         return;
      end
      if strcmpi(propertyName,searchProperty)
         if (length(cellarray) >= k+1)
            result = true;
            return
         end
      end
   end
end
