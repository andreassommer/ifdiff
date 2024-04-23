integrator = @ode45;
t0 = 0;
tf = 3;
timeinterval = [t0,tf];
initstates   = [0, 1];
p            = [0.9, 1, 9.81];

fprintf('Preprocessing...\n  ');
odeoptions = odeset( 'AbsTol', 1e-14, 'RelTol', 1e-12);
filename = 'bounceball_rhs';
tic
handlerhs_test = prepareDatahandleForIntegration(filename, 'solver', func2str(integrator), 'options', odeoptions);
toc

fprintf('Integration with ifdiff/%s...\n  ', func2str(integrator));
tic
sol_rhs_test = solveODE(handlerhs_test, timeinterval, initstates, p);
toc

% Switches
sw_pts = cell2mat(handlerhs_test.getData().SWP_detection.switchingpoints);
sw_pts_y = deval(sol_rhs_test, sw_pts);
n_sw_pts = max(size(handlerhs_test.getData().SWP_detection.switchingpoints));
fprintf('Total number of switches during integration: %d \n', n_sw_pts);

% Visualize solution
clf('reset');
axis([0 20 0 1.1]);
lineWidth = 0.8;

T_gridsize = 0.0001;
T = t0:T_gridsize:tf;
Y = deval(sol_rhs_test,T);
plot(T, abs(Y(1,:)), sw_pts, abs(sw_pts_y(1,:)), 'o', 'lineWidth', lineWidth);
legend('x_1(t)','Switches', 'Location', 'North');
sgtitle("Zeno's phenomenon in model of bouncing ball");