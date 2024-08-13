function sol = solveVDE_Gp(datahandle, sol, tspan, modelNum, sensOptions)
%SOLVEVDE_GP Solve the VDE for Gp in the interval tspan fixed to model modelNum and return the sol object
    data = datahandle.getData();

    parameters             = data.SWP_detection.parameters;
    functionRHS_original   = data.integratorSettings.preprocessed_rhs;
    functionRHS_simple_VDE = @(t, y, parameters) functionRHS_original(datahandle, t, y,  parameters);
    dim_y                  = data.computeSensitivity.dim_y;
    dim_p                  = data.computeSensitivity.dim_p;

    integrator         = sensOptions.integrator;
    integrator_options = sensOptions.integrator_options;

    data.computeSensitivity.modelStage = modelNum;
    datahandle.setData(data);

    function_p_VDE = @(t,G) VDE_RHS_p(sol, functionRHS_simple_VDE, t, G, parameters, sensOptions);
    initial_y = reshape(zeros(dim_y, dim_p), [], 1);
    sol = integrator(function_p_VDE, tspan, initial_y, integrator_options);
end

