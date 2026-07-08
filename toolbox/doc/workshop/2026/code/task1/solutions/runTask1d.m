%% Subtask a) and b)
%% Setup problem
tspan = [0, 30];
y0 = [0; 1000];
p = [3/4, 1/4];

rhs = @rhsTask1a;
integrator = @ode45;
optionsOde45 = odeset('RelTol', 1e-8, 'AbsTol', 1e-8, 'MaxStep', 0.1);

%% Solve with ode45
solutionOde45 = integrator(@(t, y) rhs(t, y, p), tspan, y0, optionsOde45);

%% Plot solution
t = linspace(tspan(1), tspan(end), 1000);
yOde45 = deval(solutionOde45, t);

figure;
plot(t, yOde45);
title('Solution with ode45');


%% Subtask c)
%% Setup problem for IFDIFF
optionsIfdiff = odeset('RelTol', 1e-8, 'AbsTol', 1e-8);
datahandle = prepareDatahandleForIntegration(rhs, 'integrator', integrator, 'options', optionsIfdiff);

%% Solve with IFDIFF
solutionIfdiff = solveODE(datahandle, tspan, y0, p);

%% Plot solution
t = linspace(tspan(1), tspan(end), 1000);
yIfdiff = deval(solutionIfdiff, t);

figure;
plot(t, yIfdiff);
title('Solution with IFDIFF');


%% Subtask d)
%% Compute sensitivity with ode45
t = linspace(tspan(1), tspan(end), 1000);
sensitivityOde45 = computeSensitivityOde45(solutionOde45, t);

%% Plot sensitivity
plotSensitivity(sensitivityOde45);


%% Subtask e)
%% Compute sensitivity with IFDIFF
t = linspace(tspan(1), tspan(end), 1000);

%sensitivityFunction = ...;
%sensitivityIfdiff = ...;

%% Plot sensitivity
plotSensitivity(sensitivityIfdiff);
