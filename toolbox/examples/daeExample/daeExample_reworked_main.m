% DAE Example Main

%% Setup and integration
integrator = @ode15s;
p          = -0.2;
x2_init    = p - 1;
x1_init    = p + x2_init^2 - x2_init;
x_init     = [x1_init; x2_init];
t0         = 0;
tf         = 5;
tspan      = [t0 tf];
M          = [1 0; 0 0];

opts = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-10 ,'RelTol', 1e-6);

datahandle = prepareDatahandleForIntegration('daeExampleRHS_reworked', 'integrator', integrator, 'options', opts);
sol_ifdiff = solveODE(datahandle, tspan, x_init, p);

sol_plain  = integrator(@(t, x) daeExampleRHS_reworked(t, x, p), tspan, x_init, opts);


%% Explicit Euler comparison
% h = 1e-6;
% tic;
% fprintf("Euler comparision: ")
% sol_euler = explicitEulerDAE(@(t,x,p) daeExampleRHS_reworked(t,x,p), M, tspan, x0, p, h, 500);
% toc;

%% Switch comparison to analytical solution
format long
numerical_switching_time = sol_ifdiff.switches
format short

%% Plots

fig2 = figure(1);
clf(fig2, "reset");

% color scheme
c_plain  = [0.5, 0.5, 0.5];
c_ifdiff = [0.0, 0.45, 0.74];
c_euler  = [0.85, 0.33, 0.1];
c_switch = [0.49, 0.18, 0.56];

hold on;

% Plain ode15s
plot_plain = plot(sol_plain.x, sol_plain.y(1,:), '-', ...
    'Color', c_plain, ...
    'DisplayName', 'Plain ode15s');

% IFDIFF
plot_ifdiff = plot(sol_ifdiff.x, sol_ifdiff.y(1,:), '-', ...
    'Color', c_ifdiff, ...
    'DisplayName', 'IFDIFF'); 

% Euler comparison
% Euler_plot = plot(sol_euler.x, sol_euler.y(1,:), ...
%     'Color', c_euler, ...
%     'DisplayName', 'Euler');

% Analytical switch
Switch_plot_ifdiff = xline(sol_ifdiff.switches, ...
    'Color', 'b', ...
    'LineWidth', 1.2, ...
    'LineStyle','--', ...
    'DisplayName', 'IFDIFF Switch');

grid on;
box on;
set(gca, 'GridAlpha', 0.15, 'FontSize', 11);
xlabel('Time (t)', 'FontSize', 12);
ylabel('State x_1(t)', 'FontSize', 12);
title('DAE Example comparison', 'FontSize', 13);

legend([plot_plain, plot_ifdiff, Switch_plot_ifdiff], ...
    'Location', 'best', 'FontSize', 10); % Euler_plot

% Zoom

hold off;