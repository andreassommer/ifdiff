function solVDE = solveVDE_Gp(datahandle, sol, tspan, modelNum, sensOptions)
%SOLVEVDE_GP Solve the VDE for Gp in the interval tspan fixed to model modelNum and return the sol object
    config = makeConfig();
    data = datahandle.getData();

    parameters = data.SWP_detection.parameters;
    if config.removeCtrlifForSensComputation
        rhs = getModelFunction(datahandle, modelNum);
    else
        rhs = data.integratorSettings.preprocessed_rhs;
    end
    dim_y      = data.computeSensitivity.dim_y;
    dim_p      = data.computeSensitivity.dim_p;

    integrator         = sensOptions.integrator;
    integrator_options = sensOptions.integrator_options;

    data.computeSensitivity.modelStage = modelNum;
    datahandle.setData(data);

    function_p_VDE = @(t,G) VDE_RHS_p(datahandle, sol, rhs, t, G, parameters, sensOptions);
    initial_y = reshape(zeros(dim_y, dim_p), [], 1);
    solVDE = integrator(function_p_VDE, tspan, initial_y, integrator_options);
end

