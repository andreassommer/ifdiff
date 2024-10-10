function [sol_original, sols_disturbed] = solveDisturbed_Gy(datahandle, tspan, modelNum, y_start, h_y, sensOptions)
%SOLVEDISTURBED_GY Solve the IVP in the interval tspan with slightly disturbed initial values.
% sol_original is the undisturbed solution; sols_disturbed is an array of solutions: each one has the initial
% y value disturbed in one component.
    data = datahandle.getData();
    functionRHS_original   = data.integratorSettings.preprocessed_rhs;
    functionRHS_simple_END = @(t,y) functionRHS_original(datahandle, t, y,  data.SWP_detection.parameters);
    dim_y                  = data.computeSensitivity.dim_y;
    unit_y = eye(dim_y);

    integrator         = sensOptions.integrator;
    integrator_options = sensOptions.integrator_options;

    data.computeSensitivity.modelStage = modelNum;
    datahandle.setData(data);

    sol_original = integrator(functionRHS_simple_END, tspan, y_start, integrator_options);
    sols_disturbed = cell(dim_y, 1);
    for j=1:dim_y
        sols_disturbed{j} = integrator(functionRHS_simple_END, tspan, y_start + h_y.*unit_y(:,j), integrator_options);
    end 
end

