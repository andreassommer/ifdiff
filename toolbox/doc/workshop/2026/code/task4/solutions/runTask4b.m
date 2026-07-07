%% Subtask a) and b)
%% Setup problem
tspan = [0, 5];
y0 = [0.1; 0];

T = 0.5;
alpha = 0.5;
p = [T, alpha];

rhs = @rhsTask4b;
integrator = @ode45;
optsIntegrator = odeset('AbsTol', 1e-10, 'RelTol', 1e-8);
datahandle = prepareDatahandleForIntegration(rhs, 'integrator', integrator, 'options', optsIntegrator);

%% Solve
solution = solveODE(datahandle, tspan, y0, p);

%% Plot solution
plotPopulation(solution);


%% Subtask c)
%% Solve for multiple parameters
%solutionFunc = @(p) ...;

solutionGrid = solveOnGrid(solutionFunc);

%% Plot solution for multiple parameters
plotPopulationGrid(solutionGrid);


%% Subtask d)
%% Compute objective
%objectiveFunc = @(solution) ...;

objectiveGrid = arrayfun(objectiveFunc, solutionGrid);

%% Plot objective
plotObjective(solutionGrid, objectiveGrid);


%% Subtask e)
%% Compute gradient
function g = computeGradient(datahandle, solutionGrid)
%g = ...;
end

gradientFunc = @(solution) computeGradient(datahandle, solution);
gradientGrid = arrayfun(gradientFunc, solutionGrid, 'UniformOutput', false);

%% Plot gradient
plotGradient(solutionGrid, objectiveGrid, gradientGrid)


%% Subtask f)
%% Optimize
function [f, g] = objWithGrad(p, solutionFunc, objectiveFunc, gradientFunc)
%f = ...;
if nargout > 1
    %g = ...;
end
end
optimizationFunc = @(p) objWithGrad(p, solutionFunc, objectiveFunc, gradientFunc);

[pOpt, objOpt] = optimizeParameters(optimizationFunc);
%solutionOpt = ...;

%% Plot optimal solution
fprintf('Optimal Parameters: T=%g, alpha=%g\n', pOpt);
fprintf('Optimal Total Harvest: %g\n', objOpt);

plotPopulation(solutionOpt);
