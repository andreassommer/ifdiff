%% DAE Example Main
integrator = @ode15s;
x0 = [1; -1];
tspan = [0 5];
M = [1 0; 0 0];
p = -0.3;

global globalTimeLog
global logEnabled
logEnabled = true;

opts_ifdiff = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-10, ...
    'RelTol', 1e-6);
opts_ode = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-10, ...
    'RelTol', 1e-6);

datahandle = prepareDatahandleForIntegration('daeExampleRHS', 'integrator', integrator, 'options', opts_ifdiff);
sol_ifdiff= solveODEWithLogging(datahandle, tspan, x0, p);
sol_plain = integrator(@(t, x) daeExampleRHS(t, x, p), tspan, x0, opts_ode);

%% Plots

% DAE solution plot
fig1 = figure(01);
hold on
IFDIFF_plot_1 = plot(sol_ifdiff.x, sol_ifdiff.y, 'ro--', 'DisplayName', 'IFDIFF'); 
Plain_plot_1  = plot(sol_plain.x, sol_plain.y, 'ko-', 'DisplayName', 'plain ode15s');
Switch_plot   = xline(sol_ifdiff.switches, 'g', 'LineWidth', 1.0, 'DisplayName', 'Switch');
legend([Plain_plot_1(1), IFDIFF_plot_1(1), Switch_plot]);
hold off

%% Visualization of Integrator Steps
%{
fig2 = figure(02);
clf;
hold on;
% all RHS calls
allRHScalls_plot_1   = plot(allT, zeros(size(allT)), 'ko-', 'DisplayName', 'All RHS Calls');
% Accepted steps
AcceptedSteps_plot_1 = plot(accT, -0.1*ones(size(accT)), 'go-', 'DisplayName', 'Accepted Steps');
% Rejected steps
RejectedSteps_plot_1 = plot(rejT, 0.1*ones(size(rejT)), 'mo-', 'DisplayName', 'Rejected Steps');

xlabel('Time t');
yticks([]);
title('Integrator Step Analysis');
legend();
hold off

% Both in 1 Plot
fig3 = figure(03);
clf;
hold on

IFDIFF_plot_2 = plot(sol_ifdiff.x, sol_ifdiff.y, 'ro--', 'DisplayName', 'IFDIFF'); %  'ro--'
%Plain_plot_2  = plot(sol_plain.x, sol_plain.y, 'bx-', 'DisplayName', 'plain ode15s'); %  'bx-'

allRHSCalls_plot_2   = plot(allT, zeros(size(allT)), 'ko-', 'DisplayName', 'All RHS Calls');
AcceptedSteps_plot_2 = plot(accT, -0.1*ones(size(accT)), 'go-', 'DisplayName', 'Accepted Steps');
RejectedSteps_plot_2 = plot(rejT, 0.1*ones(size(rejT)), 'mo-', 'DisplayName', 'Rejected Steps');

xlabel('Time t');
yticks([]);
title('Integrator Step Analysis');
legend();
hold off

%}

%disp(sol_ifdiff.switches);

%{
fig4 = figure(04);
clf;
hold on;
%timelog_diff = abs(diff(globalTimeLog));
%unique_globalTimeLog = removeConsecutiveDuplicates(globalTimeLog);
%disp(unique_globalTimeLog);
plot_1 = plot(globalTimeLog, 'o-', 'DisplayName', 'globalTimeLog');
xlabel('Integrator Steps');
ylabel('Zeit'); 
plot_switch = yline(sol_ifdiff.switches, 'rx-', 'LineWidth', 2.0, 'DisplayName', 'Switch');
legend();
hold off;
%}