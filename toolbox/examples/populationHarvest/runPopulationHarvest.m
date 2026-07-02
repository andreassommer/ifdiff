%% Setup
tspan = [0, 5];
y0 = [1; 0];
r = 1;
C = 10;
T = 5;
alpha = 0.5;
p = [r, C, T, alpha];
TMin = 0;
TMax = C;
alphaMin = 0;
alphaMax = 1;


rhs = @rhsPopulationHarvest;
integrator = @ode45;
optsIntegrator = odeset('AbsTol', 1e-10, 'RelTol', 1e-8);
datahandle = prepareDatahandleForIntegration(rhs, 'integrator', integrator, 'options', optsIntegrator);

%% Solve
solution = solveODE(datahandle, tspan, y0, p);

%% Plot solution
figPop = figure;
axPop = axes(figPop);
plotPopulation(axPop, solution);

function plotPopulation(ax, solution)
nPoints = 1000;
t = linspace(solution.x(1), solution.x(end), nPoints);
P = deval(solution, t, 1);
hold(ax, 'on');
plot(ax, t, P);
hold(ax, 'off');

title(ax, 'Population over time with threshold harvesting');
xlabel(ax, 'Time');
ylabel(ax, 'Population');
end

%% Solve for multiple parameters
solver = @(p) solveODE(datahandle, tspan, y0, p);
nT = 5;
nAlpha = 5;
TPlot = linspace(TMin, TMax, nT);
alphaPlot = linspace(alphaMin, alphaMax, nAlpha);
solutionGrid = repmat(solution, nT, nAlpha);
for idxT=1:nT
    for idxAlpha=1:nAlpha
        solutionGrid(idxT, idxAlpha) = solver([r, C, TPlot(idxT), alphaPlot(idxAlpha)]);
    end
end

%% Plot solution for multiple parameters
function plotPopulationGrid(fig, solution, T, alpha)
[nT, nAlpha] = size(solution);
tiles = tiledlayout(fig, nT, nAlpha);
for idxT=1:nT
    for idxAlpha=1:nAlpha
        ax = nexttile(tiles);
        plotPopulation(ax, solution(idxT, idxAlpha));
        title(ax, sprintf('T=%g, \\alpha=%g', T(idxT), alpha(idxAlpha)));
    end
end
title(tiles, 'Population over time with various threshold harvesting parameters')
end

figPopGrid = figure;
plotPopulationGrid(figPopGrid, solutionGrid, TPlot, alphaPlot);

%% Compute objective
objective = @(solution) sum(solution.y(:, end));
objectiveGrid = arrayfun(objective, solutionGrid);

%% Plot objective
function plotObjective(ax, objective, T, alpha)
surf(T, alpha, objective);
title(ax, 'Total harvest for various threshold harvesting parameters');
xlabel(ax, 'Harvest threshold');
ylabel(ax, 'Harvest ratio');
zlabel(ax, 'Total harvest');
end

figObj = figure;
axObj = axes(figObj);
plotObjective(axObj, objectiveGrid, TPlot, alphaPlot)

%% Compute gradient
function g = computeGradient(datahandle, solution, idxP)
sensitivity = generateSensitivityFunction(datahandle, solution, 'calcGy', false);
Gp = sensitivity(solution.x(end)).Gp;
dP = Gp(1, idxP);
dH = Gp(2, idxP);
g = dP + dH;
end

idxP = [3, 4];
gradient = @(solution) computeGradient(datahandle, solution, idxP);

gradientGrid = zeros([numel(idxP), size(solutionGrid)]);
for idxT=1:nT
    for idxAlpha=1:nAlpha
        gradientGrid(:, idxT, idxAlpha) = gradient(solutionGrid(idxT, idxAlpha));
    end
end

%% Plot gradient
function plotGradient(ax, gradient, T, alpha)
surf(T, alpha, gradient);
title(ax, 'Total harvest gradient for various threshold harvesting parameters');
xlabel(ax, 'Harvest threshold');
ylabel(ax, 'Harvest ratio');
zlabel(ax, 'Total harvest gradient');
end

figGrad = figure;
axGrad = axes(figGrad);
plotGradient(axGrad, squeeze(gradientGrid(1, :, :)), TPlot, alphaPlot)

%% Optimize
function [f, g] = objWithGrad(x, p, idxP, solver, objective, gradient)
p(idxP) = x;
solution = solver(p);
f = -objective(solution);
if nargout > 1
    g = -gradient(solution);
end
end

fun = @(x) objWithGrad(x, p, idxP, solver, objective, gradient);
x0 = [4, 0.3];
A = [];
b = [];
Aeq = [];
beq = [];
lb = [C/10, alphaMax/10];
ub = [C - C/10, alphaMax - alphaMax/10];
nonlcon = [];

optimizer = @fmincon;
optsOptimizer = optimoptions(optimizer, ...
    'Algorithm', 'trust-region-reflective', ...
    'SpecifyObjectiveGradient', true, ...
    'Display', 'iter');

[~, err] = checkGradients(fun, x0);
[x, fval, exitflag, output] = optimizer(fun, x0, A, b, Aeq, beq, lb, ub, nonlcon, optsOptimizer);

%% Plot optimal solution
fprintf('Optimal Parameters: T=%g, alpha=%g\n', x(1), x(2));
fprintf('Optimal Harvest: %g\n', fval);

pOpt = p;
pOpt(idxP) = x;
optSolution = solver(pOpt);

figPopOpt = figure;
axPopOpt = axes(figPopOpt);
plotPopulation(axPopOpt, optSolution)
title(axPopOpt, 'Population over time with optimal threshold harvesting parameters')
