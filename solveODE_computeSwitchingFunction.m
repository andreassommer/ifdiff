function solveODE_computeSwitchingFunction(datahandle)
% set up function index. 
% 
% input: datahandle with switchingIndices (probably more than one). 
% output: switching function as source code and its function handle 

% of all the switches that were detected, one only is interested in the one
% that happened as first. 
% I.e. all switchpoint points are calculated and the smallest is chosen. 
% I.e. all switching functions have to be calculated 

data = datahandle.getData();

% amount of switching functions
numberOfSwitchingIndices = length(data.SWP_detection.switchingIndices);
switchingfunctionhandles = cell(numberOfSwitchingIndices, 1);
datahandle.setData(data); 


for i = 1:numberOfSwitchingIndices
    % create switchingfunctions
    % export them as source code 
    % return function handle
    switchingfunctionhandles{i} = setUpSwitchingFunction(datahandle, i);
end

% store function handle in datahandle
data = datahandle.getData(); 
data.SWP_detection.switchingfunctionhandles = switchingfunctionhandles; 
datahandle.setData(data); 
end
