function Gp_values = generateGmatrices_intermediate_Gp_END(datahandle, timepoints, modelNum, sensOptions)
%GENERATEGMATRICES_INTERMEDIATE_GY_END approximate the parameter sensitivity Gp between two switching points
% using external numerical differentiation and return a cell array of Gp at the provided time points
    data = datahandle.getData();
    parameters    = data.SWP_detection.parameters;
    switches      = data.computeSensitivity.switches_extended;
    y_to_switches = data.computeSensitivity.y_to_switches;
    dim_y         = data.computeSensitivity.dim_y;
    dim_p         = data.computeSensitivity.dim_p;

    Gp_values = cell(1, length(timepoints));

    tspan   = [switches(modelNum), timepoints(end)];
    y_start = y_to_switches(:, modelNum);
    h_p = fdStep_getH_p(sensOptions.FDstep, parameters);
    [sol_original, sols_disturbed] = solveDisturbed_Gp(datahandle, tspan, modelNum, y_start, h_p, sensOptions);

    % Cycle through every parameter and compute the sensitivites
    y  = repmat(deval(sol_original, timepoints), [1, dim_p]);
    eval_disturb_p = cell(1, dim_p);
    for j=1:dim_p
        sol_disturb = sols_disturbed{j};
        eval_disturb_p{j} = deval(sol_disturb, timepoints);
    end
    difference = reshape((cell2mat(eval_disturb_p) - y), [], dim_p);
    count = 1 : dim_y : size(difference, 1);
    for j = 1:length(timepoints)
        Gp_values{j} = difference(count(j):j*dim_y, 1:dim_p)./reshape(h_p, 1, []);
    end
    if timepoints(1) == switches(modelNum)
        % Gp(t_0, t_0)=0. But since we apply our h-disturbance to the initial values, our solution will not reflect
        % this. Here, we correct this case.
        Gp_values{1} = zeros(dim_y, dim_p);
    end
end