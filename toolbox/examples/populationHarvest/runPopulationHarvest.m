%% Setup
tspan = [0, 10];
y0 = [10; 0];
r = 2;
C = 100;
T = 55;
alpha = 0.3;
p = [r, C, T, alpha];

rhs = @rhsPopulationHarvest;
integrator = @ode45;
optsOptimizer = odeset('AbsTol', 1e-10, 'RelTol', 1e-8);

nPlotPoints = 10000;

%% Solve
datahandle = prepareDatahandleForIntegration(rhs, 'integrator', integrator, 'options', optsOptimizer);
solution = solveODE(datahandle, tspan, y0, p);

%% Plot
tPlot = linspace(tspan(1), tspan(end), nPlotPoints);
yPlot = deval(solution, tPlot, 1);

figure;
plot(tPlot, yPlot);

%% Objective
harvest = @(H, alpha) sum(solveODE(datahandle, tspan, y0, [r, C, H, alpha]).y(:, end));

nAlpha = 20;
alphaPlot = linspace(0, 1, nAlpha);
alphaHarvest = arrayfun(@(alpha) harvest(T, alpha), alphaPlot);

nH = 20;
hPlot = linspace(0, C, nH);
hHarvest = arrayfun(@(H) harvest(H, alpha), hPlot);

%% Plot
figure;
plot(alphaPlot, alphaHarvest);

figure;
plot(hPlot, hHarvest);


%% Setup optimizer
dimY = numel(solution.y(:, 1));
dimP = numel(p);
idxP = [3, 4];
solver = @(p) solveODE(datahandle, tspan, y0, p);
obj = @(solution) sum(solution.y(:, end));
fdStep = generateFDstep(dimY, dimP);
sensFun = @(solution) generateSensitivityFunction(datahandle, solution, fdStep, 'calcGy', false, 'calcGp', true);

function [f, g] = objWithGrad(x, p, idxP, solver, obj, sensFun)
p(idxP) = x;
solution = solver(p);
f = -obj(solution);

if nargout > 1
    tEnd = solution.x(end);
    sens = sensFun(solution);
    Gp = sens(tEnd).Gp;
    dP = Gp(1, idxP);
    dH = Gp(2, idxP);
    g = -(dP + dH);
end
end

fun = @(x) objWithGrad(x, p, idxP, solver, obj, sensFun);
x0 = [T, alpha];
A = [];
b = [];
Aeq = [];
beq = [];
lb = [10, 0.1];
ub = [C, 1];
nonlcon = [];

optimizer = @fmincon;
optsOptimizer = optimoptions(optimizer, ...
    'Algorithm', 'trust-region-reflective', ...
    'SpecifyObjectiveGradient', true, ...
    'Display', 'iter');


%% Compute grid
nGridpoints = 20;
nDim = 2;
gridAxes = zeros(nGridpoints, nDim);
for i=1:nDim
    gridAxes(:, i) = linspace(lb(i), ub(i), nGridpoints);
end
[gridT, gridAlpha] = meshgrid(gridAxes(:, 1), gridAxes(:, 2));
gridObj = arrayfun(@(T, alpha) obj(solver([r, C, T, alpha])), gridT, gridAlpha);

%% Plot grid
figure;
surf(gridT, gridAlpha, gridObj);

%% Optimize
[x, fval, exitflag, output] = optimizer(fun, x0, A, b, Aeq, beq, lb, ub, nonlcon, optsOptimizer);
