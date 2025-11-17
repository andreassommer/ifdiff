function varargout = solveODE(datahandle, tspan, initialvalues, parameters)
% Integrate the preprocessed RHS with switching point detection.
% On detecting a SWP (marked by one or more ctrlifs changing value in a time step (t_i -> t_{i+1})), stop
% integration, find the exact switching point t_s. Then, extend the solution to just slightly past t_s and
% restart integration with the new model, checking for SWPs again.
% Notation: when a SWP t_s is found in the time step (t_i -> t_{i+1}), we write t1 := t_i, t2 := t_s, t3 := t_{i+1}.
%
% INPUT:
% 'datahandle':     data handle containing all the data
%                   for the switching point detection (calulated by
%                   prepareDatahandleForIntegration)
% 'tspan':          time interval of the integration
% 'initialvalues, parameters': initial values and parameters of the rhs
%
% OUTPUT:
% nargout = 1 -> ode solution object
% nargout = 2 -> ode solution object and datahandle with all data.

config = makeConfig;
initDatahandleFields(datahandle, tspan, initialvalues, parameters);

solveODE_firstTime(datahandle)
switch_detected = checkForSwitchingIndices(datahandle);

% Prepare class instances for switching/jump/model functions.
solveODE_setupFunctionStores(datahandle);

while switch_detected
    % cut last step in solution_until_t3 and it becomes solution_until_t1
    solveODE_solution_until_t1(datahandle)

    solveODE_getSwitchingFunctions(datahandle);

    solveODE_computeSwitchingPoint(datahandle);

    extendODEuntilSwitch(datahandle);

    % Determine state jump, if any
    jumpCtrlifIndices = solveODE_getJumpIndices(datahandle);
    data = datahandle.getData();
    if length(jumpCtrlifIndices) > 1
        error('Multiple jumps apply to the switch at t=%.16g\n', data.SWP_detection.switchingpoints{end});
    elseif isempty(jumpCtrlifIndices)
        data.SWP_detection.jumpFunction{end + 1} = [];
        datahandle.setData(data);
    else
        data.SWP_detection.jumpFunction{end + 1} = solveODE_getJumpFunction(datahandle, jumpCtrlifIndices);
        datahandle.setData(data);
    end

    % Set the starting value and signature for the next stage
    solveODE_prepareNextStage(datahandle);

    % chattering/inconsistent switching? --> filippov regime
    chattering = solveODE_recognizeFilippovSwitching(datahandle);
    if chattering
        solveODE_setFilippovRHS(datahandle);
        % extend solution from t2 until end of filippov regime
        extendODE_filippov_regime(datahandle);
        if checkForSwitchingIndices(datahandle)
            error('IFDIFF:switchInFilippov', 'Switching during or right after Filippov mode.');
        end

        data = datahandle.getData();
        if data.SWP_detection.t2 == tspan(2)
            % clear filippov data, serves also as indicator for inactive filippov mode
            data.sliding = extendODE_filippov_regime_cleanup(data.sliding);
            datahandle.setData(data);
            break; % reached end of time span
        end

        % Left the Filippov model and continue integration with new model:
        % Need to set switching point, switching function and new signature.
        if config.debugMode
            fprintf('Left Filippov regime.\n');
        end

        solveODE_solution_until_t1(datahandle)

        data = datahandle.getData();
        % Switching function for entry into Filippov regime.
        data.SWP_detection.switchingfunctionhandles = data.SWP_detection.switchingFunction(end);
        data.SWP_detection.switchingIndices = 1; % Doesn't matter, but required for computeSwitchingPoint
        % Assume no jumps in Filippov regime.
        data.SWP_detection.jumpFunction{end + 1} = [];
        datahandle.setData(data);
        solveODE_computeSwitchingPoint(datahandle);

        % Compute actual switching point by extending solution until alpha changes.
        extendODEuntilSwitch_Filippov(datahandle);

        % clear filippov data, serves also as indicator for inactive filippov mode
        data = datahandle.getData();
        data.sliding = extendODE_filippov_regime_cleanup(data.sliding);
        datahandle.setData(data);

        solveODE_prepareNextStage(datahandle);
    end

    % extend solution object from t2 ongoing until the next switch occurs
    extendODE_t2_to_tend_with_SWP_detection(datahandle);

    switch_detected = checkForSwitchingIndices(datahandle);
end

varargout = solveODE_assembleOutput(datahandle, nargout);

end
