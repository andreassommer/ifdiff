function newFunctionName = createSwitchingFunctionName(prefix, oldFunctionName, hash, varargin)
DELIMITER = '_';

collisionIndex = '';
if nargin > 3
    collisionIndex = num2str(varargin{1});
end

newFunctionName = [ ...
    prefix, ...
    oldFunctionName, DELIMITER, ...
    hash, DELIMITER, ...
    collisionIndex];
end
