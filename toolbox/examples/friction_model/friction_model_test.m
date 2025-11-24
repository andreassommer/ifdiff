integrator = @ode45;
t0 = 0;
tf = 12;
timeinterval = [t0,tf];
initstates   = [1.133944669704  0 ];
p(1) = 1.0;   %k
p(2) = 1.0;   %m
p(3) = 0.2;   %mu_b
p(4) = 1;     %F_s
p(5) = 3;     %delta
p(6) = 1e-15; %epsilon
p = reshape(p, [], 1);

%% preprocessing
fprintf('Preprocessing...\n  ');
odeoptions = odeset( 'AbsTol', 1e-20, 'RelTol', 1e-6);
filename = 'friction_model_RHS';
dhandle = prepareDatahandleForIntegration(filename, 'integrator', func2str(integrator), 'options', odeoptions);
fprintf('Done, now integrate...\n');

%% integrate
sol_ifdiff = solveODE(dhandle, timeinterval, initstates, p);
fprintf('Done \n');

%% results
disp(sol_ifdiff);
T = 0:0.01:12;
Y = deval(sol_ifdiff, T);
switches = sol_ifdiff.switches;

figure; hold on; box on;

a = zeros(length(sol_ifdiff.x));

plot(T, Y(1,:), 'LineWidth', 2);
plot(T, Y(2,:), 'LineWidth', 2);
plot(sol_ifdiff.x, a, 'rx', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5]);
%plot(switches, Ys(2,:), 'rx', 'MarkerSize', 8, 'LineWidth', 1.5);

for s = switches
    xline(s, '--r', 'LineWidth', 1.5);
end

xlabel('Time (s)', 'FontSize', 12);
ylabel('States', 'FontSize', 12);
title('ODE Solution to Friction Model', 'FontSize', 14);

legend({'State 1','State 2'}, 'Location', 'best');
grid on;

set(gca, 'FontSize', 12, 'LineWidth', 1.2);

disp(sol_ifdiff.idata);
disp(sol_ifdiff.stats);
