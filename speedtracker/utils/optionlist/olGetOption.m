function [value, cellarray] = olGetOption(cellarray, searchOption, defaultValue)
   % function [value, cellarray] = olGetOption(cellarray, searchOption)
   % function [value, cellarray] = olGetOption(cellarray, searchOption, defaultValue)
   %
   % Searches cellarray, that is expected to be a cell array
   % of name/value pairs, for specified option and returns
   % the associated value.
   %
   % Only the first occurance is reported.
   % The property-Strings are case-insensitive.
   %
   % If the specified value cannot be found, a 'NaN' is returned.
   % Try to check first via hasOption()-function, if the
   % the cell array contains the desired name/value pair.
   %
   %
   % INPUT:   cellarray --> cell array to process
   %       searchOption --> name of queried option
   %       defaultValue --> value to be used if queried option is not found
   %                        (optional, default is empty matrix [])
   %
   % OUTPUT:      value --> value associated with queried option name
   %          cellarray --> cell array with queried option removed
   %
   %
   %
   % Author:  Andreas Sommer, 2009,2010,2011,2016,2017,2022
   % andreas.sommer@iwr.uni-heidelberg.de
   % code@andreas-sommer.eu
   %
   %
   % History:  Sep2016 --> renamed to getOption, assert optionlist
   %           Mar2017 --> cut the cell array, if two-arg-output
   %           Dec2022 --> add default valueed
   %           Jul2024 --> renamed to olGetOption

   % was a default value provided?
   if (nargin<3), defaultValue = []; end

   % Initialize
   value = defaultValue;
   olAssertOptionlist(cellarray);

   % cycle through properties
   for k = 1:2:length(cellarray)
      optionName = cellarray{k};
      if strcmpi(optionName,searchOption)
         if (length(cellarray) >= k+1)
            value = cellarray{k+1};
            break
         end
      end
   end

   % if more than one output argument, remove the queried option
   if (nargout >= 2)
      cellarray = olRemoveOptions(cellarray, optionName);
   end
end