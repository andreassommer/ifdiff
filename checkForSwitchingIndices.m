function out = checkForSwitchingIndices(datahandle)
% When switching Indices exist, a switch occured 
data = datahandle.getData();
switchingIndices = data.SWP_detection.switchingIndices; 
out = ~isempty(switchingIndices);

% ignore a single switching index coming from a sliding switch
if isfield(data.sliding, 'index')
    sliding_index = data.sliding.index;
    if length(switchingIndices) == 1 && ~isempty(sliding_index)
        out = (switchingIndices(1) ~= sliding_index);
    end
end
