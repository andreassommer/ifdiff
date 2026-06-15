% DAE Example Main
% for more details, see [new README missing] 

%% Setup and integration
integrator = @ode15s;
p          = -0.2; % -1 < p < 0 
x0         = [1; -1+p]; % 1+p to guarantee consistent initial condition
t0         = 0;
tf         = 5;
tspan      = [t0 tf];
M          = [1 0; 0 0];

opts_ifdiff = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-8,'RelTol', 1e-6);
opts_plain  = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-6, 'RelTol', 1e-3);

sol_plain  = integrator(@(t, x) daeExampleRHS_reworked(t, x, p), tspan, x0, opts_plain);

datahandle = prepareDatahandleForIntegration('daeExampleRHS_reworked', 'integrator', integrator, 'options', opts_ifdiff);
sol_ifdiff = solveODE(datahandle, tspan, x0, p);

%% Expl. Euler comparision
h = 1e-4;
sol_euler = explicitEulerDAE(@(t,x,p) daeExampleRHS_reworked(t,x,p), 1, tspan, x0, p, h);

%% Plots
clf;
fig2 = figure(01);
hold on;
Euler_plot  = plot(sol_euler.x, sol_euler.y, 'g*--', 'DisplayName', 'Euler');
IFDIFF_plot = plot(sol_ifdiff.x, sol_ifdiff.y, 'ro--', 'DisplayName', 'IFDIFF'); 
Plain_plot  = plot(sol_plain.x, sol_plain.y, 'ko-', 'DisplayName', 'plain ode15s');
Switch_plot = xline(sol_ifdiff.switches, 'b', 'LineWidth', 1.0, 'DisplayName', 'Switch');
legend([Plain_plot(1), IFDIFF_plot(1), Euler_plot(1), Switch_plot ]); 
hold off;