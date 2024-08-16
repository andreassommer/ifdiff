function Gp_values = getGp_intermediate_VDE(datahandle, sol, timepoints, modelNum, sensOptions)
%GETGP_INTERMEDIATE_VDE approximate the parameter sensitivity Gp between two switching points
% by solving the variational differential equation and return a cell array of Gp at the provided time points
    data = datahandle.getData();
    switches      = data.computeSensitivity.switches_extended;
    dim_y         = data.computeSensitivity.dim_y;

    tspan    = [switches(modelNum), timepoints(end)];
    solVDE_p = solveVDE_Gp(datahandle, sol, tspan, modelNum, sensOptions);

    diff_y_p_sol = deval(solVDE_p, timepoints);
    Gp_values = cell(1, length(timepoints));
    for j = 1:length(timepoints)
        Gp_values{j} = reshape(diff_y_p_sol(:,j), dim_y, []);
    end
end

