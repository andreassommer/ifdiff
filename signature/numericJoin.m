%NUMERICJOIN    Convert numeric array to char array with delimiter inserted between elements.
%   char = NUMERICJOIN(numeric, delim)
function char = numericJoin(numeric, delim)
% strjoin requires a cell array of char arrays/strings
numeric = arrayfun(@num2str, numeric, 'UniformOutput', false);
char = strjoin(numeric, delim);
end
