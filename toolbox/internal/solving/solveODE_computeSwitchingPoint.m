function solveODE_computeSwitchingPoint(datahandle)
% function to compute the first occuring exact switching
% After switching functions have been computed for every ctrlif that switched, compute the
% root of each switching function and store the first (minimal in t) in the datahandle as THE switching point

config = makeConfig();
data = datahandle.getData();


% preallocate for switchingIntervals
numberofswitchingfunctions = length(data.SWP_detection.switchingIndices);
switchingpoints = zeros(1, numberofswitchingfunctions);
data.caseCtrlif = config.caseCtrlif.default;
% find zero crossing of the switching function in the time interval
datahandle.setData(data); 
for ii = 1:numberofswitchingfunctions
    
    % get initial values of bisection algorithm 
    % prepare obj bisection 
    bisection = solveODE_computeSwitchingPoint_prepareBisection(datahandle, ii);
    
    % check whether switching function is feasbile and resonable
    % could be extended in future versions to warn for unappropriate
    % switching functions
    bisection = solveODE_computeSwitchingPoint_checkSwitchingFunction(bisection); 
    
    % get root of switching function as candidate for switch
    switchingpoints(:, ii) = solveODE_computeSwitchingPoint_bisection(bisection); 
end

data = datahandle.getData(); 

% Find switch that occurs first (i.e. earliest switching time)
[firstSwitch, firstSwitchIdx] = min(switchingpoints);

data.SWP_detection.signatureSwitchIndex(end + 1) = data.SWP_detection.switchingIndices(firstSwitchIdx);
data.SWP_detection.t2 = firstSwitch;
data.SWP_detection.switchingFunction{end + 1} = data.SWP_detection.switchingfunctionhandles{firstSwitchIdx};

datahandle.setData(data);

end















