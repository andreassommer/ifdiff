% DAE Example Main
% for more details, see daeExample_README.md

%% Setup and integration
integrator = @ode15s;
x0         = [1; -1];
tspan      = [0 5];
M          = [1 0; 0 0];
p          = -0.2;

opts_ifdiff = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-9,'RelTol', 1e-6);
opts_plain  = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-9, 'RelTol', 1e-6);

datahandle = prepareDatahandleForIntegration('daeExampleRHS', 'integrator', integrator, 'options', opts_ifdiff);
sol_ifdiff = solveODE(datahandle, tspan, x0, p);
sol_plain  = integrator(@(t, x) daeExampleRHS(t, x, p), tspan, x0, opts_plain);

%% Plots
clf;
fig1 = figure(01);
hold on;
IFDIFF_plot_1 = plot(sol_ifdiff.x, sol_ifdiff.y, 'r*--', 'DisplayName', 'IFDIFF'); 
Plain_plot_1  = plot(sol_plain.x, sol_plain.y, 'k*-', 'DisplayName', 'plain ode15s');
Switch_plot   = xline(sol_ifdiff.switches, 'b', 'LineWidth', 1.0, 'DisplayName', 'Switch');
legend([Plain_plot_1(1), IFDIFF_plot_1(1), Switch_plot]);
hold off;
