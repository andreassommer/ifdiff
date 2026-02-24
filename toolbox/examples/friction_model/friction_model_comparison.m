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
p = reshape(p, [], 1);

warning('off', 'IFDIFF:chattering');

%% Solving the friction model variant without filippov mode
% %preprocessing
fprintf('Preprocessing...\n  ');
odeoptions = odeset( 'AbsTol', 1e-20, 'RelTol', 1e-6);
filename = 'friction_RHS_no_filippov';
dhandle = prepareDatahandleForIntegration(filename, 'integrator', func2str(integrator), 'options', odeoptions);
fprintf('Done, now integrate...\n');

% integrate
sol_no_filippov = solveODE(dhandle, timeinterval, initstates, p);
fprintf('Done \n');

% results
disp(sol_no_filippov);
T = t0:0.01:tf;
Y_no_fil = deval(sol_no_filippov, T);
switches = sol_no_filippov.switches;

figure(1); hold on; box on;

a = zeros(length(sol_no_filippov.x));

plot(T, Y_no_fil(1,:), 'LineWidth', 2);
plot(T, Y_no_fil(2,:), 'LineWidth', 2);
plot(sol_no_filippov.x, a, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);

for s = switches
    xline(s, '--r', 'LineWidth', 1.5);
end

xlabel('Time (s)', 'FontSize', 12);
ylabel('States', 'FontSize', 12);
title('ODE Solution to Friction Model', 'FontSize', 14);

legend({'State 1','State 2'}, 'Location', 'best');
grid on;

set(gca, 'FontSize', 12, 'LineWidth', 1.2);

%disp(sol_ifdiff.idata);
%disp(sol_ifdiff.stats);

%% Computing VDE-sensitivities

dim_y = size(sol_no_filippov.y, 1);
dim_p = length(p);
FDstep = generateFDstep(dim_y, dim_p);
integrator_options = odeset('AbsTol', 1e-14, 'RelTol', 1e-12);
sensitivities_function_VDE = generateSensitivityFunction(dhandle, sol_no_filippov, FDstep, 'integrator_options', integrator_options);
sens = sensitivities_function_VDE(T);
Gy11 = arrayfun(@(x) x.Gy(1, 1), sens);
Gy12 = arrayfun(@(x) x.Gy(1, 2), sens);
Gy21 = arrayfun(@(x) x.Gy(2, 1), sens);
Gy22 = arrayfun(@(x) x.Gy(2, 2), sens);

figure(500); box on;
subplot(2, 2, 1);
scatter(T, Gy11, 'LineWidth', 0.5, 'Color', [0, 0.5, 0], Marker='.'); hold on;
plot(sol_no_filippov.x, a, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);
for s = switches
    xline(s, '--r', 'LineWidth', 1.5);
end
xlabel('Time (s)', 'FontSize', 12);
ylabel('Gy11', 'FontSize', 12);
title('Gy11', 'FontSize', 14);
legend({'Gy11'}, 'Location', 'best');
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.2);

subplot(2, 2, 2);
scatter(T, Gy12, 'LineWidth', 0.5, 'Color', [0, 0.5, 0], Marker='.'); hold on;
plot(sol_no_filippov.x, a, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);
for s = switches
    xline(s, '--r', 'LineWidth', 1.5);
end
xlabel('Time (s)', 'FontSize', 12);
ylabel('Gy12', 'FontSize', 12);
title('Gy12', 'FontSize', 14);
legend({'Gy12'}, 'Location', 'best');
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.2);

subplot(2, 2, 3);
scatter(T, Gy21, 'LineWidth', 0.5, 'Color', [0, 0.5, 0], Marker='.'); hold on;
plot(sol_no_filippov.x, a, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);
for s = switches
    xline(s, '--r', 'LineWidth', 1.5);
end
xlabel('Time (s)', 'FontSize', 12);
ylabel('Gy21', 'FontSize', 12);
title('Gy21', 'FontSize', 14);
legend({'Gy21'}, 'Location', 'best');
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.2);

subplot(2, 2, 4);
scatter(T, Gy22, 'LineWidth', 0.5, 'Color', [0, 0.5, 0], Marker='.'); hold on;
plot(sol_no_filippov.x, a, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);
for s = switches
    xline(s, '--r', 'LineWidth', 1.5);
end
xlabel('Time (s)', 'FontSize', 12);
ylabel('Gy22', 'FontSize', 12);
title('Gy22', 'FontSize', 14);
legend({'Gy22'}, 'Location', 'best');
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.2);



%% Solving the friction model variant with filippov mode
% %preprocessing
fprintf('Preprocessing...\n  ');
filenamefil = 'friction_RHS_filippov';
dhandle_filippov = prepareDatahandleForIntegration(filenamefil, 'integrator', func2str(integrator), 'options', odeoptions);
fprintf('Done, now integrate...\n');

% integrate
sol_filippov = solveODE(dhandle_filippov, timeinterval, initstates, p);
fprintf('Done \n');

% results
disp(sol_filippov);
T = t0:0.01:tf;
Y_filippov = deval(sol_filippov, T);
switches_fil = sol_filippov.switches;

figure(2); hold on; box on;

a2 = zeros(length(sol_filippov.x));

plot(T, Y_filippov(1,:), 'LineWidth', 2);
plot(T, Y_filippov(2,:), 'LineWidth', 2);
plot(sol_filippov.x, a2, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);

for s = switches_fil
    xline(s, '--r', 'LineWidth', 1.5);
end

xlabel('Time (s)', 'FontSize', 12);
ylabel('States', 'FontSize', 12);
title('ODE Solution to Friction Model (Filippov)', 'FontSize', 14);

legend({'State 1','State 2'}, 'Location', 'best');
grid on;

set(gca, 'FontSize', 12, 'LineWidth', 1.2);

%disp(sol_ifdiff2.idata);
%disp(sol_ifdiff2.stats);

%% Compute filippov sensitivities
% to do

%% creating difference plot

figure(3); hold on; box on;

a2 = epsilon * ones(length(sol_filippov.x));
fildiff1 = abs(Y_filippov(1,:) - Y_no_fil(1,:));
fildiff2 = abs(Y_filippov(2,:) - Y_no_fil(2,:));

plot(T, fildiff1, 'LineWidth', 2);
plot(T, fildiff2, 'LineWidth', 2);
plot(sol_filippov.x, a2, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);

for s = switches
    xline(s, '--r', 'LineWidth', 1.5);
end

xlabel('Time (s)', 'FontSize', 12);
ylabel('Difference', 'FontSize', 12);
title('Difference of filippov and non-filippov integrations', 'FontSize', 14);

legend({'Diff State 1','Diff State 2'}, 'Location', 'best');
grid on;

set(gca, 'FontSize', 12, 'LineWidth', 1.2, 'YScale', 'log');

%% Display of the switching functions

nu_rel = (Y_no_fil(2,:) - p(3));

figure(4); 
subplot(2, 1, 1); hold on; box on;

scatter(T, nu_rel, 'LineWidth', 0.5, Marker='.');
plot(sol_filippov.x, 0, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);

for s = switches
    xline(s, '--r', 'LineWidth', 1.5);
end

xlabel('Time (s)', 'FontSize', 12);
ylabel('\nu_{rel} (switching function)', 'FontSize', 12);
title('Evolution of first switching condition', 'FontSize', 14);

legend({'\nu_{rel}'}, 'Location', 'best');
grid on;

set(gca, 'FontSize', 12, 'LineWidth', 1.2);

subplot(2, 1, 2); hold on; box on;

scatter(T, nu_rel, 'LineWidth', 0.5, Marker='.');
plot(sol_filippov.x, 0, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);

for s = switches
    xline(s, '--r', 'LineWidth', 1.5);
end

xlabel('Time (s)', 'FontSize', 12);
ylabel('\nu_{rel} (switching function)', 'FontSize', 12);
title('Evolution of first switching condition', 'FontSize', 14);
ylim([-2 * epsilon 2 * epsilon]);
legend({'\nu_{rel}'}, 'Location', 'best');
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.2);

warning('on', 'IFDIFF:chattering');