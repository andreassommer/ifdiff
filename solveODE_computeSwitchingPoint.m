function solveODE_computeSwitchingPoint(datahandle)
% function to compute the first occuring exact switching

% 'solution': the solution up to timeInterval(2)
% 'datahandle': data handle that contains all signature related data
% 'switchingindices': the indices of the IIf nodes we check for switches
% 'parameters': some additional parameters of the ode

% 'switchinginterval': the time interval  which contains the switching
% point - as small as the machine precision allows
% 'switchingindices': the indices of the IIf calls at which switches
% occured
% compute/build switching functions corresponding to switching indices


data = datahandle.getData();


% preallocate for switchingIntervals
numberofswitchingfunctions = length(data.SWP_detection.switchingIndices);
switchingpoints = zeros(1, numberofswitchingfunctions);
data.caseCtrlif = 0; % default case
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

% find the minimum right side of the intervals (first occuring
% switching point)
[firstswitch, index] = min(switchingpoints(1,:));

data.SWP_detection.switchingIndices  = data.SWP_detection.switchingIndices(switchingpoints(1,:) == firstswitch);
z = switchingpoints(:, switchingpoints(1,:) == firstswitch);

data.SWP_detection.t2 = z(1);
data.SWP_detection.switchingFunction{end + 1} = data.SWP_detection.switchingfunctionhandles{index}; 

datahandle.setData(data);

end
















