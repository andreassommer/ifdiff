function [pOpt, objOpt] = optimizeParameters(optimizationFunc)
optimizer = @fmincon;
optimizationProblem.objective = optimizationFunc;
optimizationProblem.x0 = [0.5, 0.25];
optimizationProblem.lb = [0, 0.2];
optimizationProblem.ub = [1, 1];
optimizationProblem.solver = func2str(optimizer);
optimizationProblem.options = optimoptions(optimizationProblem.solver, ...
    'Algorithm', 'interior-point', ...
    'SpecifyObjectiveGradient', true, ...
    'Display', 'iter');

checkGradients(optimizationProblem.objective, optimizationProblem.x0, 'Display', 'on');
[pOpt, objOpt] = optimizer(optimizationProblem);
objOpt = -objOpt;
end
