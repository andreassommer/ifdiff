% Stick-slip model with known switching point
% 
% Source: Hans Georg Bock, Christian Kirches, Andreas Meyer, Andreas Potschka:
% Numerical solution of optimal control problems with explicit and implicit switches



% initial state
x0 = [ 0 , 1 ].';

% time span
t0 = 0;
tf = 1;

odesolver = @ode23;
%%
odeoptions = odeset( 'AbsTol', 1e-10, 'RelTol', 1e-3);

fprintf('Preparing...\n  ');
tic
hdlrhs_test = prepareDatahandleForIntegration('stickslip_rhs', 'integrator', func2str(odesolver), 'options', odeoptions);
toc
%%
fprintf('Solving using ifdiff...\n  ');
tic
sol_rhs_test = solveODE(hdlrhs_test, [t0 tf], x0, {});
toc

%% 
% do explicit euler integration
fprintf('AccurateEuler integration...\n  ');
tic
Neuler = 10000000;       % number of time steps
X = zeros(2, Neuler+1);   % solution array
X(:,1) = x0;            % copy initial state
T = zeros(1, Neuler+1);   % time array
T(1) = t0;              % copy initial time point
dt = (tf-t0) / Neuler;  % time increment
for k = 1:Neuler
   T(k+1)   = t0 + k*dt;
   X(:,k+1) = X(:,k) + dt * stickslip_rhs(T(k), X(:,k));
end
toc
skipper = floor(Neuler/1000);
Teuler = T(1:skipper:end);
Xeuler = X(:,1:skipper:end);


%%
% try with ode solver
fprintf('Using matlab solver %s ...\n ', func2str(odesolver));
tic
sol_matlab = odesolver(@stickslip_rhs, [t0 tf], x0, odeoptions);
toc


%% Evaluate on Euler grid
Tode = Teuler;
Xode = deval(sol_rhs_test, Tode);

Tmatlab = Teuler;
Xmatlab = deval(sol_matlab, Tmatlab);


% differences
Xdiff1 = Xeuler - Xode;
Xdiff2 = Xmatlab - Xode;


% plot solutions
figure(545); clf;
axes = [0 1 0 1.5]; 
%ax1 = subplot(4,1,1); plot(Teuler, Xeuler, 'linewidth',1.5); legend('x_1','x_2','Location','West'); title('AccurateEuler'); axis(axes); xline(sol_rhs_test.switches(2), '--'); xline(sol_rhs_test.switches(end), '--');
ax2 = subplot(3,1,1); plot(sol_rhs_test.x  , sol_rhs_test.y ,'linewidth',1.5); legend('x_1','x_2','Location','West'); title(sprintf('%s with Switching Point Detection', func2str(odesolver))); axis(axes); xline(sol_rhs_test.switches(2), '--'); xline(sol_rhs_test.switches(end), '--');
ax3 = subplot(3,1,2); plot(Teuler  , Xdiff1,'linewidth',1.5 ); legend('x_1','x_2','Location','West'); title(sprintf('Difference between AccurateEuler and %s with Switching Point Detection', func2str(odesolver)));
ax4 = subplot(3,1,3); plot(Teuler  , Xdiff2,'linewidth',1.5 ); legend('x_1','x_2','Location','West'); title(sprintf('Difference between %s and %s with Switching Point Detection', func2str(odesolver), func2str(odesolver)));

sgtitle('Stick-Slip Model (consistent)');
linkaxes([ax1 ax2 ax3 ax4], 'x');















