function str = numericJoin(num, delim)
%str = NUMERICJOIN(num, delim)
%
%Convert numeric array to char array with delimiter inserted between elements.
%
%INPUT:
%   num - Numeric array to be converted
%       numeric array
%
%   delim - Delimiter string to be inserted between each element of num
%       char array
%
%OUTPUT:
%   str - String concatenation of the elements of num with delim inserted between each element
%       char array

% strjoin requires a cell array of char arrays/strings
num = arrayfun(@num2str, num, 'UniformOutput', false);
str = strjoin(num, delim);
end
