% Differential Algebraic Equation Example
% from Workshop 2026 (more info, see README_DAE_Workshop.md) 

%% Setup
integrator = @ode15s;
x0         = [1; -1];
t0         = 0;
tf         = 3;
tspan      = [t0 tf];
p          = -0.3;

% mass matrix
M          = [1 0; 0 0];
opts       = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-9,'RelTol', 1e-5);


%% Solution with IFDIFF
filename = 'rhsDaeExampleWorkshop';
datahandle = prepareDatahandleForIntegration(filename, 'integrator', integrator, 'options', opts);
sol_ifdiff = solveODE(datahandle, tspan, x0, p);

%% Solution with ode15s
sol_plain  = integrator(@(t, x) rhsDaeExampleWorkshop(t, x, p), tspan, x0, opts);


%% Plots

t_eval   = t0:1e-6:tf;
y_ifdiff = deval(sol_ifdiff, t_eval);
y_plain  = deval(sol_plain, t_eval);

% plot colors
c_ifdiff = [0.85, 0.33, 0.1];
c_plain  = [0.0, 0.45, 0.74];


% large scale plot
% on a larger scale both solutions look correct
fig1 = figure(1);
clf(fig1, "reset");
hold("on");
IFDIFF_plot = plot(t_eval, y_ifdiff, '-', 'Color', c_ifdiff, 'LineWidth', 1.2, 'DisplayName', 'IFDIFF'); 
Plain_plot  = plot(t_eval, y_plain, '--', 'Color', c_plain, 'DisplayName', 'plain ode15s');
legend([Plain_plot(1), IFDIFF_plot(1)]);
grid("on");
hold("off");

% zoom in at switching point
% ode15s interpolates around the switch whereas ifdiff detects and handles
% it correctly
fig2 = figure(2);
clf(fig2, "reset");
hold("on");
IFDIFF_plot = plot(t_eval, y_ifdiff, '-', 'Color', c_ifdiff, 'DisplayName', 'IFDIFF'); 
Plain_plot  = plot(t_eval, y_plain, '-', 'Color', c_plain, 'DisplayName', 'plain ode15s');
xlim([1.0664 1.0702])
ylim([0.4271 0.4277])
legend([Plain_plot(1), IFDIFF_plot(1)]);
grid("on");
hold("off");