function Gy_values = getGy_intermediate_END(datahandle, timepoints, modelNum, sensOptions)
%GETGY_INTERMEDIATE_END approximate the initial value sensitivity Gy between two switching points
% using external numerical differentiation and return a cell array of Gy at the provided time points
    data = datahandle.getData();

    switches      = data.computeSensitivity.switches_extended;
    y_to_switches = data.computeSensitivity.y_to_switches;
    dim_y         = data.computeSensitivity.dim_y;


    Gy_values = cell(1, length(timepoints));

    tspan   = [switches(modelNum), timepoints(end)];
    y_start = y_to_switches(:, modelNum);
    h_y = fdStep_getH_y(sensOptions.FDstep, y_start);
    [sol_original, sols_disturbed] = solveDisturbed_Gy(datahandle, tspan, modelNum, y_start, h_y, sensOptions);

    % Cycle through every initial value and compute the sensitivites
    y  = repmat(deval(sol_original, timepoints), [1, dim_y]);
    eval_disturb_y0 = cell(1, dim_y);
    for j=1:dim_y
        sol_disturb = sols_disturbed{j};
        eval_disturb_y0{j} = deval(sol_disturb, timepoints);
    end
    difference = reshape((cell2mat(eval_disturb_y0) - y), [], dim_y);
    count = 1 : dim_y : size(difference, 1);
    for j = 1:length(timepoints)
        Gy_values{j} = difference(count(j):j*dim_y, 1:dim_y)./reshape(h_y, 1, []);
    end
    if timepoints(1) == switches(modelNum)
        % at the switch, the sensitivity should be eye. Since we solved the ODE with y_start+h_y instead, however,
        % our END solution will also have y(t_0) = y_start+h_y. So, correct the first time point's value.
        Gy_values{1} = eye(dim_y);
    end
end