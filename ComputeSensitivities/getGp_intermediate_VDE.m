function Gp_values = getGp_intermediate_VDE(datahandle, sol, timepoints, modelNum, sensOptions)
%GETGP_INTERMEDIATE_VDE approximate the parameter sensitivity Gp between two switching points
% by solving the variational differential equation and return a cell array of Gp at the provided time points
% timepoints must be sorted ascendingly, have no duplicates, and be within model #modelNum.
    if isempty(timepoints)
        Gp_values = {};
        return;
    end
    data = datahandle.getData();
    switches      = data.computeSensitivity.switches_extended;
    dim_y         = data.computeSensitivity.dim_y;
    dim_p         = data.computeSensitivity.dim_p;

    if switches(modelNum) == timepoints(end)
        % ODE solvers will crash if you pass them identical start and end times, so we have to handle this special case
        % Note that the conditions we placed on time points mean there is exactly one point in this case
        Gp_values = {zeros(dim_y, dim_p)};
        return;
    end

    tspan    = [switches(modelNum), timepoints(end)];
    solVDE_p = solveVDE_Gp(datahandle, sol, tspan, modelNum, sensOptions);

    diff_y_p_sol = deval(solVDE_p, timepoints);
    Gp_values = cell(1, length(timepoints));
    for j = 1:length(timepoints)
        Gp_values{j} = reshape(diff_y_p_sol(:,j), dim_y, []);
    end
end

