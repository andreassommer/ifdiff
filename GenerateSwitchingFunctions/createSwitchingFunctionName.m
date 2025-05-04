function newName = createSwitchingFunctionName(prefix, rhsName, hash, collisionIndex)
%newName = CREATESWITCHINGFUNCTIONNAME(prefix, rhsName, hash, collisionIndex)
%
%Create a new unique name for a switching/jump function.
%
%INPUT:
%   prefix - Prefix added to the function name.
%   Primarily used to differentiate between switching and jump functions (e.g. sw_ and jump_)
%       char array
%
%   rhsName - Name of the RHS function.
%       char array
%
%   hash - Hash computed from a switching function signature.
%       char array
%
%   collisionIndex - Index used to handle hash collisions in the signature.
%       positive integer
%
%OUTPUT:
%   newName - Unique name for a new switching/jump function based on the following format:
%   <prefix><oldName><DELIM><hash><DELIM><collisionIndex>
%       char array

DELIMITER = '_';

collisionIndex = sprintf('%u', collisionIndex);

newName = [ ...
    prefix, ...
    rhsName, DELIMITER, ...
    hash, DELIMITER, ...
    collisionIndex];
end
