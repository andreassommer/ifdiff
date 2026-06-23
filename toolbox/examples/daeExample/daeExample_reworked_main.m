% DAE Example Main
% for more details, see [new README missing] 

%% Setup and integration
integrator = @ode15s;
x0         = [0.5;1];
p          = 2;
t0         = 0;
tf         = 2;
tspan      = [t0 tf];
M          = [1 0; 0 0];

opts = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-10,'RelTol', 1e-6);

datahandle = prepareDatahandleForIntegration('daeExampleRHS_reworked', 'integrator', integrator, 'options', opts);
sol_ifdiff = solveODE(datahandle, tspan, x0, p);

sol_plain  = integrator(@(t, x) daeExampleRHS_reworked(t, x, p), tspan, x0, opts);


%% Explicit Euler comparison
h = 1e-6;
sol_euler = explicitEulerDAE(@(t,x,p) daeExampleRHS_reworked(t,x,p), M, tspan, x0, p, h, 10);

%% Switches comparison
numerical_switching_time = sol_ifdiff.switches
analytical_switching_time = (p^2 - x0(2))/2 + t0

%% Plots
clf;
fig2 = figure(01);
hold on;
Plain_plot  = plot(sol_plain.x, sol_plain.y, 'DisplayName', 'plain ode15s', 'LineWidth', 3.0);
Euler_plot  = plot(sol_euler.x, sol_euler.y, '--', 'DisplayName', 'Euler', 'LineWidth', 2.0);
IFDIFF_plot = plot(sol_ifdiff.x, sol_ifdiff.y, 'DisplayName', 'IFDIFF', 'LineWidth', 1.0); 
Switch_plot = xline(analytical_switching_time, 'b', 'LineWidth', 1.0, 'DisplayName', 'Switch');
legend([Plain_plot, IFDIFF_plot, Euler_plot]); 
hold off;