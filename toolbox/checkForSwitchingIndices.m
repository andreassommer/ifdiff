function out = checkForSwitchingIndices(datahandle)
% When switching Indices exist, a switch occured 
data = datahandle.getData();
switchingIndices = data.SWP_detection.switchingIndices; 
out = ~isempty(switchingIndices);

% ignore a single switching index coming from a sliding switch
sliding_index = data.sliding.index;
if isscalar(switchingIndices) && ~isempty(sliding_index)
    out = (switchingIndices ~= sliding_index);
end