integrator = @ode45;
t0 = 0;
tf = 20;
timeinterval = [t0,tf];
initstates   = [1  0 ];
p            = 5.437;

%%
fprintf('Preprocessing...\n  ');
odeoptions = odeset( 'AbsTol', 1e-20, 'RelTol', 1e-12);
filename = 'canonicalExampleRHS';
tic
hdlrhs_test = prepareDatahandleForIntegration(filename, 'integrator', func2str(integrator), 'options', odeoptions);
toc

%%
fprintf('Integration with ifdiff/%s...\n  ', func2str(integrator));
tic
sol_rhs_test = solveODE(hdlrhs_test, timeinterval, initstates, p);
toc

%% 
fprintf('Integration with %s...\n  ', func2str(integrator));
tic
odesol = ode45(@(t,x) canonicalExampleRHS(t,x,p), timeinterval, initstates, odeoptions);
toc


%%
% do explicit euler integration
fprintf('AccurateEuler integration...\n  ');
tic
Neuler = 1000000;        % number of time steps
X = zeros(2, Neuler+1); % solution array
X(:,1) = initstates;    % copy initial state
T = zeros(1, Neuler+1); % time array
T(1) = t0;              % copy initial time point
dt = (tf-t0) / Neuler;  % time increment
for k = 1:Neuler
   T(k+1)   = t0 + k*dt;
   X(:,k+1) = X(:,k) + dt * canonicalExampleRHS(T(k), X(:,k), p);
end
toc
skipper = floor(Neuler/1000);
T_euler = T(1:skipper:end);
Y_euler = X(:,1:skipper:end);


%%
T = T_euler;
Y_matlabsolver = deval(odesol, T);
Y_ifdiff = deval(sol_rhs_test, T);



clf('reset')
hold on
axis([0 20 0 20])
plot(T, Y_ifdiff, '-b', 'lineWidth', 3);
plot(T, Y_matlabsolver, '--r','lineWidth', 4);
% plot(sol_rhs_test.x, 10, 'k.','lineWidth', 10, 'MarkerSize', 300);
plot(odesol.x, 0, '-k*','lineWidth', 2, 'MarkerSize', 8);
xline(sol_rhs_test.switches(1),'lineWidth', 1.5);
xline(sol_rhs_test.switches(2),'lineWidth', 1.5);
set(gca,'XTick',0:2:20); 
set(gca,'YTick',[1 5 10 15 20 25 30]); 
%legend()
hold off



%% 
% clf('reset')
% hold on
% plot(T, Y_matlabsolver, '--r','lineWidth', 2);
% plot(ode.x, 0, '-k*','lineWidth', 2, 'MarkerSize', 8);
% xline(datanyc.variable.switchingpoints{1},'lineWidth', 1.5);
% xline(datanyc.variable.switchingpoints{2},'lineWidth', 1.5);
% set(gca,'XTick',0:2:20); 
% set(gca,'YTick',[1 5 10 15 20 25 30]); 
% hold off


%% Differences Plot


% differences
Xdiff1 = Y_euler - Y_ifdiff;
Xdiff2 = Y_matlabsolver - Y_ifdiff;

% plot solutions
figure(545); clf;
axes = [0 20 0 30]; 
ax2 = subplot(3,1,1); plot(T, Y_ifdiff,'linewidth',1.5); legend('x_1','x_2','Location','West'); title(sprintf('%s with Switching Point Detection', func2str(odesolver))); axis(axes); xline(sol_rhs_test.switches(1), '--'); xline(sol_rhs_test.switches(2), '--');
ax3 = subplot(3,1,2); plot(T,   Xdiff1,'linewidth',1.5); legend('x_1','x_2','Location','West'); title(sprintf('Difference between AccurateEuler and %s with Switching Point Detection', func2str(odesolver)));
ax4 = subplot(3,1,3); plot(T,   Xdiff2,'linewidth',1.5); legend('x_1','x_2','Location','West'); title(sprintf('Difference between %s and %s with Switching Point Detection', func2str(odesolver), func2str(odesolver)));
sgtitle('Canonical Example');
linkaxes([ax2 ax3 ax4], 'x');





