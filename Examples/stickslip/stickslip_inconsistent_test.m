% Stick-slip model with INCONSISTENT switching
%
% Source: Hans Georg Bock, Christian Kirches, Andreas Meyer, Andreas Potschka:
% Numerical solution of optimal control problems with explicit and implicit switches

% BROKEN !!!


% initial state
x0 = [ 1.133944669704, 0 ].';

% time span
t0 = 0;
tf = 12;

% do explicit euler integration
tic
Neuler = 100000;        % number of time steps
X = zeros(2, Neuler);   % solution array
X(:,1) = x0;            % copy initial state
T = zeros(1, Neuler);   % time array
T(1) = t0;              % copy initial time point
dt = (tf-t0) / Neuler;  % time increment
for k = 1:Neuler
   T(k+1)   = t0 + k*dt;
   X(:,k+1) = X(:,k) + dt * stickslip_inconsistent_rhs(T(k), X(:,k));
end
fprintf('Euler integration took %g seconds.\n', toc());
Teuler = T;
Xeuler = X;

% try with ode-solver
odesolver = @ode113;
odeopts = odeset(); % defaults
odeopts = odeset(odeopts, 'RelTol', 1.0d-8, 'AbsTol', 1.0d-14);
tic
sol = odesolver(@stickslip_inconsistent_rhs, [t0 tf], x0);
fprintf('%s integration took %g seconds.\n', func2str(odesolver), toc());
Tode = Teuler;
Xode = deval(sol, Tode);
%Xode45 = deval(incon_sol_rhs_test, Tode);

% differences
Xdiff1 = Xeuler - Xode;
Xdiff2 = Xeuler - Xode45;

% plot solutions
figure(545); clf;
% ax1 = subplot(3,1,1); plot(Teuler, Xeuler); legend('x_1','x_2','Location','West'); title('Euler');
% ax2 = subplot(3,1,2); plot(Tode  , Xode  ); legend('x_1','x_2','Location','West'); title(func2str(odesolver));
% ax3 = subplot(3,1,3); plot(Tode  , Xdiff ); legend('x_1','x_2','Location','West'); title('Difference');

ax1 = subplot(5,1,1); plot(Teuler, Xeuler, incon_sol_rhs_test.x  , incon_sol_rhs_test.y, '.k'); legend('x_1','x_2','Location','West'); title('Euler');
ax2 = subplot(5,1,2); plot(Tode  , Xode  ); legend('x_1','x_2','Location','West'); title(func2str(odesolver));
ax3 = subplot(5,1,3); plot(Tode  , Xdiff1 ); legend('x_1','x_2','Location','West'); title('Difference Teuler, Tode');
ax4 = subplot(5,1,4); plot(Tode  , Xdiff2 ); legend('x_1','x_2','Location','West'); title('Difference Teuler Tode45 SWP detection');
ax5 = subplot(5,1,5); plot(incon_sol_rhs_test.x  , incon_sol_rhs_test.y); legend('x_1','x_2','Location','West'); title('ode45 with SWP detection');



sgtitle('Stick-Slip Model (inconsistent)');
linkaxes([ax1 ax2 ax3], 'x');
linkaxes([ax1 ax2], 'y');












