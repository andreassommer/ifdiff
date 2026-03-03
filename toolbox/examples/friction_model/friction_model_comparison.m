%% Source: Stick-Slip Vibrations Induced by Alternate Friction Models
% paper by: R. Leine, D. van Campen, A. de Kraker, and L. van den Steen
% doi: 10.1023/A:1008289604683

% The system describes dry friction of a spring suspended weight sitting on a 
% constantly moving conveyor belt. The weight moves along with the belt
% until spring tension becomes too high and the weight is pushed back.
% This creates a switched periodic motion. 

% The corresponding ODE can be formulated in a filippov and non-filippov
% variant and serves as a perfect example to test the accuracy of not only
% the filippov integration but also the resulting sensitivities.

% Both formulations can be found in "Numerical Solution of Optimal Control 
% Problems with Explicit and Implicit Switches" by Andreas Meyer
% chapter: 15.3

integrator = @ode45;
t0 = 0;
tf = 30;
timeinterval = [t0,tf];
initstates   = [1.133944669704  0 ];
p(1) = 1.0;   %k
p(2) = 1.0;   %m
p(3) = 0.2;   %mu_b
p(4) = 1;     %F_s
p(5) = 3;     %delta
epsilon = 1e-11;
p(6) = epsilon; %epsilon

% saving current warning state for filippov detection (then turn off warning)
initial_filippov_warning_state = warning('query', 'IFDIFF:chattering').state;
warning('off', 'IFDIFF:chattering');

%% Solving the friction model variant without filippov mode
% preprocessing
fprintf('Preprocessing...\n  ');
odeoptions = odeset( 'AbsTol', 1e-20, 'RelTol', 1e-6);
filename = 'friction_RHS_no_filippov';
dhandle = prepareDatahandleForIntegration(filename, 'integrator', integrator, 'options', odeoptions);
fprintf('Done, now integrate...\n');

% integrate
try
    sol_no_filippov = solveODE(dhandle, timeinterval, initstates, p);
catch ME
    warning(initial_filippov_warning_state, 'IFDIFF:chattering');
    warning('Problem integrating model variant wihtout filippov behaviour...');
    rethrow(ME);
end
fprintf('Done \n');

% results
T = t0:0.01:tf;
Y_no_fil = deval(sol_no_filippov, T);

figure(1); hold on; box on;

integrator_steps_marker_vals = zeros(length(sol_no_filippov.x));

plot(T, Y_no_fil(1,:), 'LineWidth', 2);
plot(T, Y_no_fil(2,:), 'LineWidth', 2);
plot(sol_no_filippov.x, integrator_steps_marker_vals, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);
xline(sol_no_filippov.switches, '--r', 'LineWidth', 1.5);

xlabel('Time (s)', 'FontSize', 12);
ylabel('States', 'FontSize', 12);
title('ODE Solution to Friction Model', 'FontSize', 14);

legend({'Position of Weight','Velocity of Weight'}, 'Location', 'best');
grid on;

set(gca, 'FontSize', 12, 'LineWidth', 1.2);

%% Computing VDE-sensitivities

dim_y = size(sol_no_filippov.y, 1);
dim_p = length(p);
FDstep = generateFDstep(dim_y, dim_p);
integrator_options = odeset('AbsTol', 1e-14, 'RelTol', 1e-12);
try
    sensitivities_function_VDE = generateSensitivityFunction(dhandle, sol_no_filippov, FDstep, 'integrator_options', integrator_options);
    sens = sensitivities_function_VDE(T);
catch ME
    warning(initial_filippov_warning_state, 'IFDIFF:chattering');
    warning('Problem with sensitivities in model variant wihtout filippov behaviour...');
    rethrow(ME)
end
Gy11 = arrayfun(@(x) x.Gy(1, 1), sens);
Gy12 = arrayfun(@(x) x.Gy(1, 2), sens);
Gy21 = arrayfun(@(x) x.Gy(2, 1), sens);
Gy22 = arrayfun(@(x) x.Gy(2, 2), sens);

figure(500); box on;

Gy = {Gy11, Gy12, Gy21, Gy22};
names = {'Gy11','Gy12','Gy21','Gy22'};

% plot the sensitivities w.r.t. the initial states
for k = 1:4
    subplot(2,2,k)
    hold on
    
    scatter(T, Gy{k}, 'LineWidth',0.5,'Color',[0 0.5 0],'Marker','.')
    plot(sol_no_filippov.x, integrator_steps_marker_vals, 'rx','MarkerSize',8,'LineWidth',1,'Color',[0 0 0.5])

    xline(sol_no_filippov.switches,'--r','LineWidth',1.5);

    xlabel('Time (s)','FontSize',12)
    ylabel(names{k},'FontSize',12)
    title(names{k},'FontSize',14)
    legend(names{k},'Location','best')
    grid on
    set(gca,'FontSize',12,'LineWidth',1.2)
end


%% Solving the friction model variant with filippov mode
% preprocessing
fprintf('Preprocessing...\n  ');
filenamefil = 'friction_RHS_filippov';
dhandle_filippov = prepareDatahandleForIntegration(filenamefil, 'integrator', integrator, 'options', odeoptions);
fprintf('Done, now integrate...\n');

% integrate
try
    sol_filippov = solveODE(dhandle_filippov, timeinterval, initstates, p);
catch
    warning(initial_filippov_warning_state, 'IFDIFF:chattering');
    warning('Problem integrating model variant wiht filippov behaviour...');
    rethrow(ME);
end
fprintf('Done \n');

% results
T = t0:0.01:tf;
Y_filippov = deval(sol_filippov, T);

figure(2); hold on; box on;

integrator_steps_marker_fil = zeros(length(sol_filippov.x));

plot(T, Y_filippov(1,:), 'LineWidth', 2);
plot(T, Y_filippov(2,:), 'LineWidth', 2);
plot(sol_filippov.x, integrator_steps_marker_fil, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);

xline(sol_filippov.switches, '--r', 'LineWidth', 1.5);

xlabel('Time (s)', 'FontSize', 12);
ylabel('States', 'FontSize', 12);
title('ODE Solution to Friction Model (Filippov)', 'FontSize', 14);

legend({'Position of Weight','Velocity of Weight'}, 'Location', 'best');
grid on;

set(gca, 'FontSize', 12, 'LineWidth', 1.2);

%% Compute filippov sensitivities
% to do

%% creating difference plot

figure(3); hold on; box on;

integrator_steps_marker_fil = epsilon * ones(length(sol_filippov.x));
fildiff = abs(Y_filippov - Y_no_fil);

plot(T, fildiff(1,:), T, fildiff(2,:), 'LineWidth', 2);
plot(sol_filippov.x, integrator_steps_marker_fil, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);

xline(sol_no_filippov.switches, '--r', 'LineWidth', 1.5);

xlabel('Time (s)', 'FontSize', 12);
ylabel('Difference', 'FontSize', 12);
title('Difference of filippov and non-filippov integrations', 'FontSize', 14);

legend({'Diff Position','Diff Velocity'}, 'Location', 'best');
grid on;

set(gca, 'FontSize', 12, 'LineWidth', 1.2, 'YScale', 'log');

%% Display of the switching functions

nu_rel = (Y_no_fil(2,:) - p(3));

figure(4); 
subplot(2, 1, 1); hold on; box on;

scatter(T, nu_rel, 'LineWidth', 0.5, Marker='.');
plot(sol_filippov.x, 0, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);

xline(sol_no_filippov.switches, '--r', 'LineWidth', 1.5);

xlabel('Time (s)', 'FontSize', 12);
ylabel('\nu_{rel} (switching function)', 'FontSize', 12);
title('Evolution of first switching condition', 'FontSize', 14);

legend({'\nu_{rel}'}, 'Location', 'best');
grid on;

set(gca, 'FontSize', 12, 'LineWidth', 1.2);

subplot(2, 1, 2); hold on; box on;

scatter(T, nu_rel, 'LineWidth', 0.5, Marker='.');
plot(sol_filippov.x, 0, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);

xline(sol_no_filippov.switches, '--r', 'LineWidth', 1.5);

xlabel('Time (s)', 'FontSize', 12);
ylabel('\nu_{rel} (switching function)', 'FontSize', 12);
title('Evolution of first switching condition', 'FontSize', 14);
ylim([-2 * epsilon 2 * epsilon]);
legend({'\nu_{rel}'}, 'Location', 'best');
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.2);

% return warining state to what it was before running the code
warning(initial_filippov_warning_state, 'IFDIFF:chattering');