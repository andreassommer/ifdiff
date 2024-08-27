integrator = @ode45;
t0 = 0;
tf = 0.5+10*eps;
timeinterval = [t0,tf];
initstates   = [1];
p            = 0;

fprintf('Preprocessing...\n  ');
odeoptions = odeset( 'AbsTol', 1e-20, 'RelTol', 1e-12, 'MaxStep', 2);
filename = 'sign_inconsistent_rhs';
tic
datahandle = prepareDatahandleForIntegration(filename, ...
    'integrator', func2str(integrator), 'options', odeoptions);
toc

fprintf('Integration with ifdiff/%s...\n  ', func2str(integrator));
tic
sol_rhs_test = solveODE(datahandle, timeinterval, initstates, p);
toc

% Read out number of switches during integration
n_switches = max(size(datahandle.getData().SWP_detection.switchingpoints));
fprintf('Total number of switches during integration: %d \n', n_switches);

sw_points   = cell2mat(datahandle.getData().SWP_detection.switchingpoints);
sw_points_y = deval(sol_rhs_test, sw_points);

% Visualize solution
figure(1);
clf('reset');
grid on
scale = 4*eps;
ax1 = subplot(1,2,1); plot(sol_rhs_test.x, sol_rhs_test.y(1,:));
% 
hold on;
ax2 = subplot(1,2,2); plot(sol_rhs_test.x, sol_rhs_test.y(1,:), sw_points, sw_points_y, 'o'); 
legend('x(t)','Switches','Location','West');
axis([0.5, 0.5+eps, -scale, scale]);
hold off;


sgtitle('Inconsistently switching sign-equation');