% Stick-slip model with INCONSISTENT switching
%
% Source: Hans Georg Bock, Christian Kirches, Andreas Meyer, Andreas Potschka:
% Numerical solution of optimal control problems with explicit and implicit switches

% initial state
x0 = [ 0.0000001, 0.2 ].';

% time span
t0 = 0;
tf = 0.1;

% prepare datahandle
fprintf('Preprocessing...\n  ');
filename = 'stickslip_inconsistent_rhs_highfreq';
integrator = @ode45;
odeopts = odeset('RelTol',1e-10, 'AbsTol',1e-12); % defaults
datahandle = prepareDatahandleForIntegration(filename, 'solver', func2str(integrator), 'options', odeopts);
% integrate with ifdiff
fprintf('Integration with ifdiff/%s...\n  ', func2str(integrator));
tic
ifdiff_sol = solveODE(datahandle, [t0 tf], x0, []);
fprintf('ifdiff/%s integration took %g seconds.\n', func2str(integrator), toc());

% Switches
sw_pts = cell2mat(datahandle.getData().SWP_detection.switchingpoints);
sw_pts_y = deval(ifdiff_sol, sw_pts);
n_sw_pts = length(sw_pts);
fprintf('Switching events during integration: %d.\n', n_sw_pts);


% evaluate
T = t0:0.00001:tf;
Xifdiff = deval(ifdiff_sol, T);


% plot solutions
figure(545); clf;
lineWidth = 1;

plot(T, Xifdiff, sw_pts, sw_pts_y(2,:), 'o', 'lineWidth', lineWidth); 
% note: switches only occur in second component x_2
legend('x_1(t)','x_2(t)','Switches', 'Location', 'East');
sgtitle('Stick-Slip Model');