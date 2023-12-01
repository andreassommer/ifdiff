function status = analyseSignature(t, x, flag, datahandle)
% output function for the integration of the ODE; returns status = 1 to
% stop the integration; compares the current signature (signature of the
% last function evaluation of the RHS) with the last signature in
% signatureArray (the fixed signature that is used for the current
% integration step)

% At the start of integration, a solver calls ODEPLOT(TSPAN,Y0,'init') to
% initialize the output function.  After each integration step to new time
% point T with solution vector Y the solver calls STATUS = ODEPLOT(T,Y,'').
% If the solver's 'Refine' property is greater than one (see ODESET), then
% T is a column vector containing all new output times and Y is an array
% comprised of corresponding column vectors.  The STATUS return value is 1
% if the STOP button has been pressed and 0 otherwise.  When the
%     integration is complete, the solver calls ODEPLOT([],[],'done').

% 't': time of the last successful integration step (or last steps)
% 'y': y value of the last integration step (or last steps)
% 'flag': different flags yield to different results ('init' + [] +
% 'done' have to be implemented)
% 'datahandle': data handle which contains all signature related staff
%
% 'status': the status of the output function, status = 0: nothing to do
%  status = 1: stop/halt integration
data = datahandle.getData();

switch flag
    % initialization, before integrating
    case 'init'
        
    case []
        
        status = 0;
        
        % compute RHS one last time to make sure the most recent evaluation is actually at t+h.
        % data.forcedBranching.switch_cond is determined by the most recent execution of the RHS.
        % ode78 and ode89 do not evaluate intermediate time points in increasing order as they compute continuous
        % extensions. This can lead to switching points being detected but then "forgotten".
        if (length(t) == 1)
            data.integratorSettings.preprocessed_rhs(datahandle, t, x, data.SWP_detection.parameters);
        else
            data.integratorSettings.preprocessed_rhs(datahandle, t(end), x(:,end), data.SWP_detection.parameters);
        end
        data = datahandle.getData();

        cond = analyseSignature_checkForSwitch(...
            data.forcedBranching.switch_cond_forcedBranching, ...
            data.forcedBranching.switch_cond);
        % cond = true; switch occured, step not accepted
        % cond = false; no switch occured, step accepted
        
        if cond
            % a switch has occured
            status = 1;
            % disp('A switch has occured');  % ONLY FOR DEBUG
        else
            % t_i becomes t_i+1 however, since no switch occured, remains
            % the same as before.
            data.forcedBranching.switch_cond    = zeros(1,length(data.forcedBranching.switch_cond_forcedBranching));
            data.forcedBranching.ctrlif_index   = zeros(1,length(data.forcedBranching.ctrlif_index_forcedBranching));
            data.forcedBranching.function_index = cell(length(data.forcedBranching.function_index_forcedBranching),1);
        end
        
    case 'done'
        
        if ~isempty(data.forcedBranching.switch_cond)
            
            data.SWP_detection.switch_cond_t1 = data.forcedBranching.switch_cond_forcedBranching;
            data.SWP_detection.switch_cond_t2 = [];
            data.SWP_detection.switch_cond_t3 = data.forcedBranching.switch_cond;
            
            data.SWP_detection.ctrlif_index_t1 = data.forcedBranching.ctrlif_index_forcedBranching;
            data.SWP_detection.ctrlif_index_t2 = [];
            data.SWP_detection.ctrlif_index_t3 = data.forcedBranching.ctrlif_index;
            
            data.SWP_detection.function_index_t1 = data.forcedBranching.function_index_forcedBranching;
            data.SWP_detection.function_index_t2 = [];
            data.SWP_detection.function_index_t3 = data.forcedBranching.function_index;
            
            datahandle.setData(data);
            data.SWP_detection.switchingIndices = getSwitchingIndices(datahandle, 1);
        else
            data.SWP_detection.switchingIndices = {};
        end
        
end



datahandle.setData(data);

end









