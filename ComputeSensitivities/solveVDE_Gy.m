function solVDE = solveVDE_Gy(datahandle, sol, tspan, modelNum, sensOptions)
%SOLVEVDE_GY Solve the VDE for Gy in the interval tspan fixed to model modelNum and return the sol object
    data = datahandle.getData();

    parameters             = data.SWP_detection.parameters;
    functionRHS_original   = data.integratorSettings.preprocessed_rhs;
    functionRHS_simple_VDE = @(t, y, parameters) functionRHS_original(datahandle, t, y,  parameters);
    dim_y                  = data.computeSensitivity.dim_y;


    integrator         = sensOptions.integrator;
    integrator_options = sensOptions.integrator_options;

    data.computeSensitivity.modelStage = modelNum;
    datahandle.setData(data);

    function_y_VDE = @(t,G) VDE_RHS_y(sol, functionRHS_simple_VDE, t, G, parameters, sensOptions);
    initial_y = reshape(eye(dim_y), [], 1);
    solVDE = integrator(function_y_VDE, tspan, initial_y, integrator_options);
end

