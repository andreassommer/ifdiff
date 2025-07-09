integrator = @ode45;
t0 = 0;
tf = 20;
timeinterval = [t0,tf];
initstates   = [1  0 ];
p            = 5.437;

%%
fprintf('Preprocessing...\n  ');
odeoptions = odeset( 'AbsTol', 1e-20, 'RelTol', 1e-12);
filename = 'canonicalNestedSubFunctionRHS';
th = tic();
dhandle = prepareDatahandleForIntegration(filename, 'integrator', func2str(integrator), 'options', odeoptions);
time_prepare = toc(th); fprintf('Took %g seconds\n', time_prepare);

%%
fprintf('Integration with ifdiff/%s...\n  ', func2str(integrator));
th = tic();
sol_ifdiff = solveODE(dhandle, timeinterval, initstates, p);
time_ifdiff = toc(th); fprintf('Took %g seconds\n', time_ifdiff);

%% 
fprintf('Integration with %s...\n  ', func2str(integrator));
th = tic();
sol_matlab = integrator(@(t,x) canonicalExampleRHS(t,x,p), timeinterval, initstates, odeoptions);
time_matlab = toc(th); fprintf('Took %g seconds\n', time_matlab);


%%
% do explicit euler integration
fprintf('AccurateEuler integration...\n  ');
th = tic();
N_euler = 1000000;       % number of time steps
X = zeros(2, N_euler+1); % solution array
X(:,1) = initstates;     % copy initial state
T = zeros(1, N_euler+1); % time array
T(1) = t0;               % copy initial time point
dt = (tf-t0) / N_euler;  % time increment
for k = 1:N_euler
   T(k+1)   = t0 + k*dt;
   X(:,k+1) = X(:,k) + dt * canonicalExampleRHS(T(k), X(:,k), p);
end
time_euler = toc(th); fprintf('Took %g seconds\n', time_euler);
skipper = floor(N_euler/1000);
T_euler = T(1:skipper:end);
Y_euler = X(:,1:skipper:end);


%%
T = T_euler;
Y_matlabsolver = deval(sol_matlab, T);
Y_ifdiff       = deval(sol_ifdiff, T);



%% PLOTTING
fignum = 544; figure(fignum); clf('reset'); hold('on');
ymax = 20; % set to multiple of 5
axis([0 tf 0 ymax])
plot(T, Y_ifdiff      , 'b-' , 'lineWidth', 3);
plot(T, Y_euler       , 'c-' , 'LineWidth', 1);
plot(T, Y_matlabsolver, 'r--', 'lineWidth', 1);
plot(sol_matlab.x, zeros(size(sol_matlab.x)), 'k*', 'MarkerSize', 8);   % step sizes by matlab integrator
xline(sol_ifdiff.switches(1), '-', 'lineWidth', 1.0);
xline(sol_ifdiff.switches(2), '-', 'lineWidth', 1.0);
set(gca,'XTick',0:2:tf); 
set(gca,'YTick',[1 5:5:ymax]); 
title('Canonical Example:  Comparison of Results');
legend(sprintf('ifdiff/%s (%5.3f seconds)'        , func2str(integrator), time_ifdiff), '', ...
       sprintf('accurate Euler (%5.3f seconds)'                         , time_euler) , '', ...
       sprintf('matlab/%s (%5.3f seconds)  WRONG!', func2str(integrator), time_matlab), '', ...
       sprintf('matlab/%s steps'                  , func2str(integrator))                 , ...
       'switches', '', ...
       'Location', 'NorthWest');



%% Differences Plot
Ydiff_Euler  = Y_euler        - Y_ifdiff;
Ydiff_Matlab = Y_matlabsolver - Y_ifdiff;

% plot prepare
fignum = fignum + 1; figure(fignum); clf;
ymax = 30;
axes = [0 tf 0 ymax]; 
lw = 1.5;

% plot ifdiff
ax2 = subplot(3,1,1); plot(T, Y_ifdiff, 'linewidth', lw); 
legend('x_1','x_2','Location','West'); 
title(sprintf('ifdiff/%s with Switching Point Detection', func2str(integrator))); 
axis(axes); 
% plot switches
xline(sol_ifdiff.switches(1), '--', 'DisplayName', 'Switches'); 
xline(sol_ifdiff.switches(2), '--', 'DisplayName', '');

ax3 = subplot(3,1,2); plot(T, Ydiff_Euler ,'linewidth', lw); 
legend('x_1','x_2','Location','West'); 
title(sprintf('Difference between AccurateEuler and ifdiff/%s ', func2str(integrator)));
text(t0+0.2, max(Ydiff_Euler(:))*0.94, 'note the scale')

ax4 = subplot(3,1,3); plot(T, Ydiff_Matlab,'linewidth', lw);
legend('x_1','x_2','Location','West');
title(sprintf('Difference between matlab/%1$s and ifdiff/%1$s', func2str(integrator)));

sgtitle('Canonical Example:  Comparison');
linkaxes([ax2 ax3 ax4], 'x');





