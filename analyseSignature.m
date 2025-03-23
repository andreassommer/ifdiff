function status = analyseSignature(t, x, flag, datahandle, debugMode)
% output function for the integration of the ODE; returns status = 1 to
% stop the integration; compares the current signature (signature of the
% last function evaluation of the RHS) with the last signature in
% signatureArray (the fixed signature that is used for the current
% integration step)

% When the integration is complete, the solver calls OutputFcn([],[],'done').
%
% INPUT:
% 't':      time of the last successful integration step (or last steps)
% 'y':      y value of the last integration step (or last steps)
% 'flag':   Type of call. 
%           'init' -> Before the integration.
%           []     -> After a successful time-step.
%           'done' -> After integration is complete. 't' and 'x' are not
%                     passed.
%                     Note: Integration can be complete either because the
%                           end of the timespan or because the integration
%                           has been stopped, i.e., after status=1 has been
%                           returned.
%                     
% 'datahandle': data handle which contains all signature related staff
% 'debugMode'   Set true for analyseSignature to store more information.
%
%
%
% OUTPUT:
% 'status': The status of the output function.
%           status = 0: nothing to do; status = 1: stop/halt integration

data = datahandle.getData();

switch flag
    case 'init'
        % nothing to do.

    case []
        % events monitoring
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
        
        signature_changed = 0;
        sliding_mode_left = 0;
        % 'normal' ifdiff mode
        if isempty(data.sliding.filippov_rhs)
            signature_changed = analyseSignature_checkForSwitch(...
                data.forcedBranching.switch_cond_forcedBranching, ...
                data.forcedBranching.switch_cond);
        % sliding mode: filippov rhs active
        else
            % compute convexification parameter alpha and check its value
            tol = data.integratorSettings.options.AbsTol;
            alpha = data.sliding.alpha_temp;
            if alpha(end) <= tol || alpha >= 1-tol
                sliding_mode_left = 1;
            end

            % store sliding mode info
            if debugMode
                sliding_cif_idx = data.sliding.ctrlif_index;
                sliding_fct_idx = data.sliding.function_index;
                data.sliding.convexification.t(end+1:end+length(t)) = t; 
                data.sliding.convexification.alpha(end+1:end+length(t)) = alpha;
                data.sliding.convexification.ctrlif_index(end+1:end+length(t)) = sliding_cif_idx*ones(1,length(t));
                data.sliding.convexification.function_index(end+1:end+length(t)) = sliding_fct_idx*ones(1,length(t));
            end
            
        end

        data.forcedBranching.switchDetected = signature_changed;
        data.sliding.sliding_mode_left = sliding_mode_left;

        if signature_changed || sliding_mode_left
                status = 1;
            else
                % t_i becomes t_i+1. however, since no switch occured, it remains the same as before.
                data.forcedBranching.switch_cond    = zeros(1,length(data.forcedBranching.switch_cond_forcedBranching));
                data.forcedBranching.ctrlif_index   = zeros(1,length(data.forcedBranching.ctrlif_index_forcedBranching));
                data.forcedBranching.function_index = cell(length(data.forcedBranching.function_index_forcedBranching),1);
        end
        
    case 'done'
        
        if data.forcedBranching.switchDetected
            
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
            data.forcedBranching.switchDetected = 0;
        else
            data.SWP_detection.switchingIndices = {};
        end

end

datahandle.setData(data);

end