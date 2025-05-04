function str = arrayStrJoin(array, delim, conversionChar)
%str = ARRAYSTRJOIN(array, delim, conversionChar)
%
%Convert array to char array with delimiter inserted between elements.
%
%INPUT:
%   array - Array to be converted.
%       array
%
%   delim - Delimiter string to be inserted between each element of the array.
%       char array
%
%   conversionChar - Conversion character used in sprintf specifying the conversion of array entries.
%
%OUTPUT:
%   str - String concatenation of the elements of array with delim inserted between each element.
%       char array

if iscell(array)
    str = sprintf([conversionChar, delim], array{:});
else
    str = sprintf([conversionChar, delim], array);
end

% Remove extra delimiter at the end.
str = str(1:end-length(delim));
end
