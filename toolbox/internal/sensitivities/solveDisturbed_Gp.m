function [sol_original, sols_disturbed] = solveDisturbed_Gp(datahandle, tspan, modelNum, y_start, h_p, sensOptions)
%SOLVEDISTURBED_GP Solve the IVP in the interval tspan with slightly disturbed parameters.
% sol_original is the undisturbed solution; sols_disturbed is an array of solutions: each one has the
% parameter disturbed in one component.
config = makeConfig();
data = datahandle.getData();

signature = data.SWP_detection.signature{modelNum};
% Special handling for Filippov model.
if iscell(signature)
    % Assume we don't start in Filippov (given since Filippov can only begin after a switch).
    switchingFunction = data.SWP_detection.switchingFunction{modelNum - 1};
    functionRHS_original = @(datahandle, t, y, p) slidingFilippovRHS_oneSwitch( ...
        datahandle, ...
        signature{1}, ...
        signature{2}, ...
        switchingFunction, t, y, p);
else
    if config.removeCtrlifForSensComputation
        functionRHS_original = getModelFunction(datahandle, modelNum);
    else
        functionRHS_original = data.integratorSettings.preprocessed_rhs;
    end
end

parameters             = data.SWP_detection.parameters;
functionRHS_simple_END = @(t,y) functionRHS_original(datahandle, t, y,  data.SWP_detection.parameters);
dim_p                  = data.computeSensitivity.dim_p;

unit_p = eye(dim_p);

integrator         = sensOptions.integrator;
integrator_options = sensOptions.integrator_options;

data.computeSensitivity.modelStage = modelNum;
datahandle.setData(data);

sol_original = integrator(functionRHS_simple_END, tspan, y_start, integrator_options);
sols_disturbed = cell(dim_p, 1);
for j=1:dim_p
    parameters_new = parameters + h_p.*unit_p(:,j);
    functionRHS_simple_disturb = @(t,y) functionRHS_original(datahandle, t, y,  parameters_new);
    sols_disturbed{j} = integrator(functionRHS_simple_disturb, tspan, y_start, integrator_options);
end

end
