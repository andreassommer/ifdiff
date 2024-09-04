initPaths();

dose            = 100; % mg i guess?
frequency       = 12;  % how often a new dose is administered, in hours

serumHalfLife   = 6;   % elimination half-life in blood
stomachHalfLife = 1/6; % elimination half-life in stomach (determines how fast it gets absorbed)
bioavailability = 0.8;

bloodVolume     = 9; % liters


p  = [dose frequency serumHalfLife stomachHalfLife bioavailability bloodVolume];
x0 = [0; dose];
t0 = 0;
tF = 30;

solver  = @ode15s;
options = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);

datahandle = prepareDatahandleForIntegration('pharmacokineticsRHS', ...
    'solver', func2str(solver), ...
    'options', options);
sol = solveODE(datahandle, [t0 tF], x0, p);

% plot the solution (only the serum concentration)
T = t0:0.01:tF;
plot(T, deval(sol, T, 1), 'LineWidth', 2, 'Color', 'blue', 'DisplayName', 'C (mg/l)');
hold on;
plot(sol.switches, deval(sol, sol.switches, 1), 'o', ...
    'Color', [0.6 0.6 0.6], ...
    'MarkerSize', 12, ...
    'LineWidth', 2, ...
    'DisplayName', sprintf('doses(%dmg)', dose));
legend('Location', 'Northwest');