function out = checkForSwitchingIndices(datahandle)
% When switching Indices exist, a switch occured 
data = datahandle.getData();
switchingIndices = data.SWP_detection.switchingIndices; 
out = ~isempty(switchingIndices);

% ignore a single switching index coming from a sliding switch
if isfield(data.integratorSettings, 'filippov_ctrlif_index')
    filippov_ctrlif_index = data.integratorSettings.filippov_ctrlif_index;
    if ~isempty(filippov_ctrlif_index) && length(switchingIndices) == 1
        out = (switchingIndices(1) ~= filippov_ctrlif_index);
    end
end
