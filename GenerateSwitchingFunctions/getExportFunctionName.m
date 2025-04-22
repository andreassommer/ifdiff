function name = getExportFunctionName(functionName, exportIndex)
%name = GETEXPORTFUNCTIONNAME(functionName, exportIndex)
%
%Get the name of an individual (helper) function from the name of a switching/jump function.
%Note that the RHS is always assigned index 1 and helper functions are numbered sequentially.
%
%INPUT:
%   functionName - Name of the switching/jump function.
%       char array
%
%   exportIndex - Index of the (helper) function in export array assigned during creation of switching/jump function.
%       positive integer
%
%OUTPUT:
%   name - Name of the individual function based on the following format:
%   <functionName><DELIM><exportIndex>
%       char array
%
%See also CREATESWITCHINGFUNCTIONNAME

DELIMITER = '_';

name = [functionName, DELIMITER, num2str(exportIndex)];
end
