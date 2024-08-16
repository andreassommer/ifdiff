function Gy_values = getGy_intermediate_VDE(datahandle, sol, timepoints, modelNum, sensOptions)
%GETGY_INTERMEDIATE_VDE approximate the initial value sensitivity Gy between two switching points
% by solving the variational differential equation and return a cell array of Gy at the provided time points
    data = datahandle.getData();
    switches      = data.computeSensitivity.switches_extended;
    dim_y         = data.computeSensitivity.dim_y;

    tspan    = [switches(modelNum), timepoints(end)];
    solVDE_y = solveVDE_Gy(datahandle, sol, tspan, modelNum, sensOptions);

    diff_y_y0_sol = deval(solVDE_y, timepoints);
    Gy_values = cell(1, length(timepoints));
    for j = 1:length(timepoints)
        Gy_values{j} = reshape(diff_y_y0_sol(:,j), dim_y, []);
    end
end

