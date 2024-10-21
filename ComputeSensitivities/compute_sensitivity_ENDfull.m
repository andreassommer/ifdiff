function sensitivities = compute_sensitivity_ENDfull(datahandle, timepoints, sol, FDstep, Gy_flag, Gp_flag, directions_y, directions_p)
%COMPUTE_SENSITIVITY_ENDFULL Compute sensitivities using full external numerical differentiation: Solve the IVP with
% slightly disturbed initial values y0+h and then approximate the sensitivity at time t by the finite difference
% Gy(t, t0) ~~ (y(t0, y0+h) - h(t0, y0))/h
% (analogous for p). This method does not work for time points that coincide with switches. The function errors in this
% case.
    if ~isempty(intersect(timepoints, sol.switches))
        error('Calculation of sensitivity at a switch with END_full not possible.')
    end

    sensData = generateSensData(1);
    sensData.timepoints = timepoints;
    
    if Gy_flag
        sensData.Gy = compute_sensitivity_ENDfull_y(datahandle, sol, timepoints, FDstep, directions_y);
    end
         
    if Gp_flag
        sensData.Gp = compute_sensitivity_ENDfull_p(datahandle, sol, timepoints, FDstep, directions_p);
    end
    sensitivitiesOutput = assembleSensitivityOutput(sensData, timepoints, Gy_flag, Gp_flag, []);
    sensitivities(:) = sensitivitiesOutput;
end

