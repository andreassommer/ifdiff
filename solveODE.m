function varargout = solveODE(datahandle, tspan, initialvalues, parameters)
% Integrate the rhs with the in prepareDatahandle chosen parameters (typ of
% solver, toleranz and accuracy of the ODE options etc.) with incorporated
% switching point detection (SWP_detection).
% The integration is stopped as soon as a switch appears. The switching point is
% calculated. The integration continues until the switching point and starts again
% from the switching point (and then stops at the next switch etc.).
% 
% 
% 
% INPUT:
% 'datahandle':     data handle containing all the data
%                   for the switching point detection (calulated by
%                   prepareDatahandleForIntegration)
% 'tspan':          time interval of the integration
% 'initialvalues, parameters': initial values and parameters of the rhs
%
%
% OUTPUT:
% nvargout = 1 -> ode solution object
% nvargout = 2 -> ode solution object and datahandle with all data.


% Notation:
%
% one has several time points that have to be considered:
%
% timepoint t3 ~ t_iplus1: immediate integration point of the ODE solving algorithm
% after a switch has occured (i.e. after the switch)
% algorithm ends if t3 = tspan(2)
%
% timepoint t2 ~ t_s: smallest number (w.r.t. to the machine precision) that is
% above the switch (i.e. after the first switch)
%
% timepoint t1 ~ t_i: last integration point of the ODE solving algorithm
% before a switch has occured (i.e. before the switch)




% by that one secures that the integration with SWP_detection (Switching Point
% Detection) can be repeated unproblematic
% and set first signature of rhs
preModifyDataHandle(datahandle, tspan, initialvalues, parameters);



% solve the ODE for the first time with switching point detection
% stop integeration when switch is detected
% creates .solution object with ODE struct until t3
solveODE_firstTime(datahandle)


switch_detected = checkForSwitchingIndices(datahandle);

while switch_detected
    % cut last step in solution_until_t3 and it becomes solution_until_t1
    % t1 ~ t_i
    solveODE_solution_until_t1(datahandle)
    
    % assemble and export switching function
    solveODE_computeSwitchingFunction(datahandle);
    
    % apply root finding algorithm to determine switch
    solveODE_computeSwitchingPoint(datahandle);
    
    extendODEuntilSwitch(datahandle);

    % Determine state jump, if any
    jumpCtrlifIndices = solveODE_getJumpIndices(datahandle);
    if length(jumpCtrlifIndices) > 1
        error('Multiple jumps apply to the switch at t=%16.16f\n', data.SWP_detection.switchingpoints{end});
    elseif isempty(jumpCtrlifIndices)
        data = datahandle.getData();
        data.SWP_detection.jumpFunction{end + 1} = [];
        datahandle.setData(data);
    else
        data = datahandle.getData();
        data.SWP_detection.jumpFunction{end + 1} = setUpJumpFunction(datahandle, jumpCtrlifIndices);
        datahandle.setData(data);
    end

    % Set the starting value and signature for the next stage
    solveODE_prepareNextStage(datahandle);

    % extend solution object from t2 ongoing until the next switch occurs
    extendODE_t2_to_tend_with_SWP_detection(datahandle);
        
    switch_detected = checkForSwitchingIndices(datahandle);
end

varargout = solveODE_assembleOutput(datahandle, nargout);

end























