function newFunctionName = createSwitchingFunctionName(oldFunctionName, hash, varargin)
DELIMITER = '_';
config = makeConfig();

collisionIndex = '';
if nargin > 2
    collisionIndex = num2str(varargin{1});
end

newFunctionName = [ ...
    config.switchingFunctionNamePrefix, DELIMITER, ...
    oldFunctionName, DELIMITER, ...
    hash, DELIMITER, ...
    collisionIndex];
end
