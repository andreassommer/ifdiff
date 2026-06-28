%% Setup
tspan = [0, 10];
y0 = 10;
r = 2;
K = 100;
H = 60;
alpha = 0.7;
p = [r, K, H, alpha];

rhs = @rhsPopulationHarvest;
integrator = @ode45;
optsOptimizer = odeset('AbsTol', 1e-10, 'RelTol', 1e-8);

nPlotPoints = 10000;

%% Solve
datahandle = prepareDatahandleForIntegration(rhs, 'integrator', integrator, 'options', optsOptimizer);
solution = solveODE(datahandle, tspan, y0, p);

%% Plot
tPlot = linspace(tspan(1), tspan(end), nPlotPoints);
yPlot = deval(solution, tPlot);

figure;
plot(tPlot, yPlot);

%% Objective
harvest = @(H, alpha) objPopulationHarvest(solveODE(datahandle, tspan, y0, [r, K, H, alpha]), H, alpha);

nAlpha = 20;
alphaPlot = linspace(0, 1, nAlpha);
alphaHarvest = arrayfun(@(alpha) harvest(H, alpha), alphaPlot);

nH = 20;
hPlot = linspace(0, K, nH);
hHarvest = arrayfun(@(H) harvest(H, alpha), hPlot);

%% Plot
figure;
plot(alphaPlot, alphaHarvest);

figure;
plot(hPlot, hHarvest);


%% Setup optimizer
function [f, g] = objWithGrad(x, datahandle, solution, dimP)
f = harvest(x(1), x(2));

if nargout > 1
    dimY = numel(solution.y(:, 1));
    fdStep = generateFDstep(dimY, dimP);
    sensFun = generateSensitivityFunction(datahandle, solution, fdStep);
    
end
end
x0 = [H, alpha];
A = [];
b = [];
Aeq = [];
beq = [];
lb = [0, 0];
ub = [K, 1];
nonlcon = [];

optimizer = @fmincon;
optsOptimizer = optimoptions(optimizer, ...
    'Algorithm', 'trust-region-reflective', ...
    'SpecifyObjectiveGradient', true, ...
    );

%% Optimize
[x, fval, exitflag, output] = optimizer()
