% Task 3 Solution
%% Setup and integration
integrator = @ode15s;
x0         = [1; -1];
tspan      = [0 3];
M          = [1 0; 0 0];
p          = -0.5;
opts       = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-9,'RelTol', 1e-6);


%% a) Solution with IFDIFF
datahandle = prepareDatahandleForIntegration('rhsTask3', 'integrator', integrator, 'options', opts);
sol_ifdiff = solveODE(datahandle, tspan, x0, p);

%% b) Solution with ode15s
sol_plain  = integrator(@(t, x) rhsTask3(t, x, p), tspan, x0, opts);


%% Plots ( c) comparison)
c_ifdiff = [0.85, 0.33, 0.1];
c_plain  = [0.0, 0.45, 0.74];

fig1 = figure(01);
clf;
hold on;
IFDIFF_plot = plot(sol_ifdiff.x, sol_ifdiff.y,'--', 'Color', c_ifdiff, 'Linewidth', 2.0, 'DisplayName', 'IFDIFF'); 
Plain_plot = plot(sol_plain.x, sol_plain.y,'-', 'Color', c_plain, 'DisplayName', 'plain ode15s');
legend([Plain_plot(1), IFDIFF_plot(1)]);
hold off;
