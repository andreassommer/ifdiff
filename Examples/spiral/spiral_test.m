integrator = @ode45;
t0 = 0;
tf = 0.5;
timeinterval = [t0,tf];
initstates = [0, 1];
p = [];

fprintf('Preprocessing...\n  ');
odeoptions = odeset( 'AbsTol', 1e-8, 'RelTol', 1e-6, 'MaxStep', 10000);
filename = 'spiral_rhs';
tic
handlerhs_test = prepareDatahandleForIntegration(filename, 'solver', func2str(integrator), 'options', odeoptions);
toc

% solution
fprintf('Integration with ifdiff/%s...\n  ', func2str(integrator));
tic
sol_rhs_test = solveODE(handlerhs_test, timeinterval, initstates, p);
toc

% switching points
sw_points   = cell2mat(handlerhs_test.getData().SWP_detection.switchingpoints);
sw_points_y = deval(sol_rhs_test, sw_points);

% Read out number of switches during integration
n_switches = max(size(sw_points));
fprintf('Total number of switches during integration: %d \n', n_switches);
fprintf('Switches occur whenever the trajectory crosses the borders of a quadrant.\n');

% Visualize solution
clf('reset');
hold on
grid on
axis([-1, 1, -1, 1]);
plot(sol_rhs_test.y(1,:), sol_rhs_test.y(2,:), sw_points_y(1,:), sw_points_y(2,:), 'o');
legend('(x_1(t), x_2(t))','Switches','Location','West');
hold off
sgtitle("Zeno's phenomenon in the spiral equation");