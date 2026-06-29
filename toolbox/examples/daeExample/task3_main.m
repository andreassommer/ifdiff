% DAE Example Main

%% Setup and integration
integrator = @ode15s;
p          = 0.5;
x1_init    = 1.0;
x2_init    = 1.4;
x_init     = [x1_init, x2_init];
t0         = 0;
tf         = 5;
tspan      = [t0 tf];
M          = [1 0; 0 0];

opts = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-12 ,'RelTol', 1e-6);

datahandle = prepareDatahandleForIntegration('task3RHS', 'integrator', integrator, 'options', opts);
sol_ifdiff = solveODE(datahandle, tspan, x_init, p);

sol_plain  = integrator(@(t, x) task3RHS(t, x, p), tspan, x_init, opts);


%% Switching time computed by IFDIFF
format long
numerical_switching_time = sol_ifdiff.switches
format short


%% Plots

fig2 = figure(1);
clf(fig2, "reset");

% color scheme
c_ifdiff = [0.0, 0.45, 0.74];
c_plain  = [0.85, 0.33, 0.1];
c_switch = [0.49, 0.18, 0.56];

hold on;

% Plain ode15s
plot_plain_1 = plot(sol_plain.x, sol_plain.y(1,:), '-', ...
    'Color', c_plain, ...
    'LineWidth', 1.3, ... 
    'DisplayName', 'Plain ode15s');

plot_plain_2 = plot(sol_plain.x, sol_plain.y(2,:), '-', ...
    'Color', c_plain, ...
    'LineWidth', 1.3, ...
    'DisplayName', 'Plain ode15s');

% IFDIFF
plot_ifdiff_1 = plot(sol_ifdiff.x, sol_ifdiff.y(1,:), '-', ...
    'Color', c_ifdiff, ...
    'DisplayName', 'IFDIFF'); 

plot_ifdiff_2 = plot(sol_ifdiff.x, sol_ifdiff.y(2,:), '-', ...
    'Color', c_ifdiff, ...
    'DisplayName', 'IFDIFF'); 

% Switch 
Switch_plot_ifdiff = xline(sol_ifdiff.switches, ...
    'Color', 'b', ...
    'LineWidth', 1.2, ...
    'LineStyle','--', ...
    'DisplayName', 'IFDIFF Switch');

grid on;
box on;
set(gca, 'GridAlpha', 0.15, 'FontSize', 11);
xlabel('Time (t)', 'FontSize', 12);
ylabel('State x(t)', 'FontSize', 12);
title('DAE Example comparison', 'FontSize', 13);
legend([plot_plain_2, plot_ifdiff_2, Switch_plot_ifdiff(1)], ...
       'Location', 'best', 'FontSize', 10); 