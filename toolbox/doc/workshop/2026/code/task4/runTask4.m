%% Subtask a) and b)
%% Setup problem
%tspan = ...;
%y0 = ...;

T = 0.5;
alpha = 0.5;
p = [T, alpha];

rhs = @rhsTask4;
integrator = @ode45;
optsIntegrator = odeset('AbsTol', 1e-10, 'RelTol', 1e-8);
%datahandle = ...;

%% Solve
%solution = ...;

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


%% End of subtasks
%% Helper functions
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

function gridSolution = solveOnGrid(solutionFunc)
TMin = 0;
TMax = 1;
alphaMin = 0;
alphaMax = 1;
nT = 5;
nAlpha = 5;

T = linspace(TMin, TMax, nT);
alpha = linspace(alphaMin, alphaMax, nAlpha);

for idxT=1:nT
    for idxAlpha=1:nAlpha
        gridSolution(idxT, idxAlpha) = solutionFunc([T(idxT), alpha(idxAlpha)]); %#ok<AGROW>
    end
end
end

function plotPopulation(solution, ax)
if nargin < 2
    fig = figure;
    ax = axes(fig);
end

nPoints = 1000;
t = jumpLinspace(solution.x(1), solution.x(end), solution.switches, nPoints);
P = deval(solution, t, 1);
plot(ax, t, P);

xlim(ax, 'tight');
ylim(ax, 'tight');

grid(ax, 'on');

title(ax, sprintf('Population over time with threshold harvesting (T=%g, \\alpha=%g)', solution.parameters));
xlabel(ax, 'Time');
ylabel(ax, 'Population');
end

function plotPopulationGrid(solution)
[nT, nAlpha] = size(solution);
p = {solution.parameters};
T = cellfun(@(p) p(1), p(1:nT));

fig = figure;
tiles = tiledlayout(fig, nT, nAlpha);
for idx=1:numel(solution)
    ax = nexttile(tiles);
    plotPopulation(solution(idx), ax);

    yticks(ax, T);
    yl = ylim(ax);
    ylim(ax, [yl(1), T(find(yl(2) < T, 1))]);

    title(ax, sprintf('T=%g, \\alpha=%g', p{idx}));
end
title(tiles, 'Population over time for various threshold harvesting parameters')
end

function plotObjective(solutionGrid, objectiveGrid, ax)
if nargin < 3
    fig = figure;
    ax = axes(fig);
end

p = reshape({solutionGrid.parameters}, size(solutionGrid));
T = cellfun(@(p) p(1), p);
alpha = cellfun(@(p) p(2), p);

surfc(ax, T, alpha, objectiveGrid, 'FaceAlpha', 0.5);
title(ax, 'Total harvest for various threshold harvesting parameters');
xlabel(ax, 'Harvest threshold');
ylabel(ax, 'Harvest ratio');
zlabel(ax, 'Total harvest');
end

function plotGradient(solutionGrid, objectiveGrid, gradientGrid)
fig = figure;
ax = axes(fig);

plotObjective(solutionGrid, objectiveGrid, ax);

p = reshape({solutionGrid.parameters}, size(solutionGrid));
T = cellfun(@(p) p(1), p);
alpha = cellfun(@(p) p(2), p);

gradientGrid = reshape(cell2mat(gradientGrid), size(solutionGrid, 1), numel(p{1}), size(solutionGrid, 2));
gradientGrid = permute(gradientGrid, [2, 1, 3]);

gradientNorm = vecnorm(gradientGrid, 2, 1);
gradientGrid = gradientGrid ./ (gradientNorm + eps);
arrowLength = 0.075 * max(T(end) - T(1), alpha(end) - alpha(1));

dT = squeeze(gradientGrid(1, :, :));
dAlpha = squeeze(gradientGrid(2, :, :));
Z = zeros(size(objectiveGrid));

hold(ax, 'on');
quiver3(ax, T, alpha, objectiveGrid, arrowLength * dT, arrowLength * dAlpha, Z, 0, ...
    'Color', 'black', 'LineWidth', 2, 'MaxHeadSize', 0.1);
hold(ax, 'off');

title(ax, 'Total harvest and gradient for various threshold harvesting parameters');
end
