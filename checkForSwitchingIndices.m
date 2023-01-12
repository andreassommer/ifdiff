function out = checkForSwitchingIndices(datahandle)
% When switching Indices exist, a switch occured 
data = datahandle.getData(); 
out = ~isempty(data.SWP_detection.switchingIndices);

end
