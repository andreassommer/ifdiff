%% Subtask a) and b)
%% Setup problem
%tspan = ...;
%y0 = ...;
%p = ...;

rhs = @rhsTask1;
integrator = @ode45;
optionsOde45 = odeset('RelTol', 1e-8, 'AbsTol', 1e-8);

%% Solve with ode45
%solutionOde45 = ...;

%% Plot solution
t = linspace(tspan(1), tspan(end), 1000);
%yOde45 = ...;

figure;
plot(t, yOde45);
title('Solution with ode45');


%% Subtask c)
%% Setup problem for IFDIFF
optionsIfdiff = odeset('RelTol', 1e-8, 'AbsTol', 1e-8);
%datahandle = ...;

%% Solve with IFDIFF
%solutionIfdiff = ...;

%% Plot solution
t = linspace(tspan(1), tspan(end), 1000);
%yIfdiff = ...;

figure;
plot(t, yIfdiff);
title('Solution with IFDIFF');


%% Subtask d)
%% Compute sensitivity with ode45
t = linspace(tspan(1), tspan(end), 1000);
%sensitivityOde45 = computeSensitivityOde45(solutionOde45, t);

%% Plot sensitivity
plotSensitivity(sensitivityOde45);


%% Subtask e)
%% Compute sensitivity with IFDIFF
t = linspace(tspan(1), tspan(end), 1000);

%sensitivityFunction = ...;
%sensitivityIfdiff = ...;

%% Plot sensitivity
plotSensitivity(sensitivityIfdiff);
