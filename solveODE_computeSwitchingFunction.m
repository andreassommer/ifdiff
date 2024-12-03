function solveODE_computeSwitchingFunction(datahandle, factory)
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
for i = 1:numberOfSwitchingIndices
    % create switchingfunctions
    % export them as source code 
    % return function handle
    sI = data.SWP_detection.switchingIndices(i);
    signature = SwitchingFunctionSignature( ...
        data.mtreeplus{2,1}, ...
        data.SWP_detection.switch_cond_t1(1:sI), ...
        data.SWP_detection.ctrlif_index_t1(1:sI), ...
        data.SWP_detection.function_index_t1(1:sI) ...
        );
    switchingfunctionhandles{i} = factory.get(signature);
end

% store function handle in datahandle
data = datahandle.getData(); 
data.SWP_detection.switchingfunctionhandles = switchingfunctionhandles; 
datahandle.setData(data); 
end
