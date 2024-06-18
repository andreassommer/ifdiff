function out = checkForSwitchingIndices(datahandle)
% When switching Indices exist, a switch occured 
data = datahandle.getData();
switchingIndices = data.SWP_detection.switchingIndices; 
out = ~isempty(switchingIndices);

% ignore ctrlif_index in sliding mode
filippov_ctrlif_index = data.integratorSettings.filippov_ctrlif_index;
if ~isempty(filippov_ctrlif_index) && length(switchingIndices) == 1
    % set out = false if the only switching index is filippov_ctrlif_index
    out = (switchingIndices(1) ~= filippov_ctrlif_index);
end

end
