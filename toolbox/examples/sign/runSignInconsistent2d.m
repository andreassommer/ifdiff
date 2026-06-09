integrator = @ode45;
t0 = 0;
tf = 1; % tf = 0.5+30*eps;
timeinterval = [t0,tf];
initstates   = [1, 1];
p            = 0;

fprintf('Preprocessing...\n  ');
odeoptions = odeset( 'AbsTol', 1e-14, 'MaxStep', 2);
filename = 'rhsSignInconsistent2d';
tic
datahandle = prepareDatahandleForIntegration(filename, ...
    'solver', integrator, 'options', odeoptions);
toc

fprintf('Integration with ifdiff/%s...\n  ', func2str(integrator));
tic
sol_rhs_test = solveODE(datahandle, timeinterval, initstates, p);
% sol_ode45 = ode45(@(t,x) sign_inconsistent_rhs_2d(t,x,p), timeinterval, initstates);
toc

% Read out number of switches during integration
n_switches = max(size(datahandle.getData().SWP_detection.switchingpoints));
fprintf('Total number of switches during integration: %d \n', n_switches);

sw_points   = cell2mat(datahandle.getData().SWP_detection.switchingpoints);
sw_points_y = deval(sol_rhs_test, sw_points);

% Visualize solution
fig = figure(1);
clf(fig, 'reset');
scale = 4*eps;
ax1 = subplot(1,3,1); plot(sol_rhs_test.x, sol_rhs_test.y(1,:));
ax2 = subplot(1,3,2); plot(sol_rhs_test.x, sol_rhs_test.y(1,:), sw_points, sw_points_y, 'o'); 
ax3 = subplot(1,3,3); plot(sol_rhs_test.x, sol_rhs_test.y(2,:));

grid([ax1, ax2, ax3], 'on');
legend(ax2, 'x(t)','Switches','Location','West');
axis(ax2, [0.5, 0.5+eps, -scale, scale]);
xlim([ax1, ax3], [0, 1]);

sgtitle('Inconsistently switching sign-equation');