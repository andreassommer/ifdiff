integrator = @ode45;
t0 = 0;
tf = 20;
timeinterval = [t0,tf];
initstates   = [1 0 1 0 0 1 0 0];
p            = 5.437;

%%
fprintf('Preprocessing...\n  ');
odeoptions = odeset( 'AbsTol', 1e-20, 'RelTol', 1e-12);
filename = 'ExtendedCanonicalSys_rhs';
th = tic();
dhandle = prepareDatahandleForIntegration(filename, 'integrator', func2str(integrator), 'options', odeoptions);
time_prepare = toc(th); fprintf('Took %g seconds\n', time_prepare);

%%
fprintf('Integration with ifdiff/%s...\n  ', func2str(integrator));
th = tic();
sol_ifdiff = solveODE(dhandle, timeinterval, initstates, p);
time_ifdiff = toc(th); fprintf('Took %g seconds\n', time_ifdiff);

%% Plotting of the solutions
T = linspace(0, 20, 200);
Y_ifdiff = deval(sol_ifdiff, T);
%disp(Y_ifdiff(1,:))
fignum = 544; figure(fignum); clf('reset'); hold('on');
ymax = 20; % set to multiple of 5
axis([0 tf 0 ymax])
plot(T, Y_ifdiff(7,:), 'b-', 'lineWidth', 3);
xline(sol_ifdiff.switches(1), '-', 'lineWidth', 1.0);
xline(sol_ifdiff.switches(2), '-', 'lineWidth', 1.0);
set(gca,'XTick',0:2:tf);
set(gca,'YTick',[1 5:5:ymax]); 
title('Extended Canonical Example');