% DAE Example Main

%% Setup and integration
integrator = @ode15s;
p          = -0.2;
x2_init    = p - 1;
x1_init    = p + x2_init^2 - x2_init;
x_init = [x1_init; x2_init];
t0         = 0;
tf         = 5;
tspan      = [t0 tf];
M          = [1 0; 0 0];

opts = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-10,'RelTol', 1e-6);

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
analytical_switching_time = 2*(p-x2_init) - log(abs(p/x2_init))
error_numerical_switching_time = abs(analytical_switching_time - numerical_switching_time)
format short

%% Plots
% clf;
% fig2 = figure(01);
% hold on;
% Plain_plot  = plot(sol_plain.x, sol_plain.y, 'x', 'DisplayName', 'plain ode15s', 'LineWidth', 0.5);
% IFDIFF_plot = plot(sol_ifdiff.x, sol_ifdiff.y, 'DisplayName', 'IFDIFF', 'LineWidth', 1.0); 
% Euler_plot  = plot(sol_euler.x, sol_euler.y, '--', 'DisplayName', 'Euler', 'LineWidth', 1.0);
% Switch_plot = xline(analytical_switching_time, 'b', 'LineWidth', 1.0, 'DisplayName', 'analytical Switch');
% legend([Plain_plot, IFDIFF_plot, Euler_plot]); 
% hold off;

clf;
fig2 = figure(1); 

% color scheme
c_plain  = [0.5, 0.5, 0.5];
c_ifdiff = [0.0, 0.45, 0.74];
c_euler  = [0.85, 0.33, 0.1];
c_switch = [0.49, 0.18, 0.56];

hold on;

% Plain ode15s
plot_plain = plot(sol_plain.x, sol_plain.y(1,:), 'x', ...
    'Color', c_plain, ...
    'DisplayName', 'Plain ode15s');

% IFDIFF
plot_ifdiff = plot(sol_ifdiff.x, sol_ifdiff.y(1,:), '--', ...
    'Color', c_ifdiff, ...
    'DisplayName', 'IFDIFF'); 

% Euler comparison
% Euler_plot = plot(sol_euler.x, sol_euler.y(1,:), ...
%     'Color', c_euler, ...
%     'DisplayName', 'Euler');

% Analytical switch
Switch_plot = xline(analytical_switching_time, ...
    'Color', c_switch, ...
    'LineWidth', 1.2, ...
    'DisplayName', 'Analytical Switch');


grid on;
box on;
set(gca, 'GridAlpha', 0.15, 'FontSize', 11);
xlabel('Time (t)', 'FontSize', 12);
ylabel('State x_1(t)', 'FontSize', 12);
title('DAE Example comparison', 'FontSize', 13);

legend([plot_plain, plot_ifdiff, Switch_plot], ...
    'Location', 'best', 'FontSize', 10); % Euler_plot

% Zoom
ts = analytical_switching_time;
xlim([ts - 0.03, ts + 0.03]);

y_vis = sol_ifdiff.y(1, abs(sol_ifdiff.x - ts) <= 0.3);
ylim([min(y_vis), max(y_vis)] + [-0.05, 0.005]);

hold off;