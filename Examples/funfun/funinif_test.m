% Test if function call in if condition is allowed

% initialize
x0 = 1;
t0 = 0;
tf = 9;
tspan = [t0 tf];
T = t0:((tf-t0)/100):tf;

% setup
odesolver = @ode45;
options = odeset('AbsTol', 1e-15, 'RelTol', 1e-3);
% options = odeset('AbsTol', 1e-20, 'RelTol', 1e-8, 'MaxStep', 1e-3);
rhs_name = 'funinif_rhs'; 
% rhs_name = 'funinif_rhs';

% try with ode-solver
tic
solode = odesolver(@(t,x) funinif_rhs(t,x), tspan, x0, options);
fprintf('%s integration took %g seconds.\n', func2str(odesolver), toc());
X = deval(solode, T);

% ifdiff
tic
hdl = prepareDatahandleForIntegration(rhs_name, 'solver', func2str(odesolver), 'options', options);
fprintf('Ifdiff handle preparation took %g seconds.\n', toc());
tic
[solif, dataif] = solveODE(hdl, tspan, x0, []);
fprintf('Ifdiff integration took %g seconds.\n', toc());
XX = deval(solif, T);

% plot solutions
figure(313); clf;
subplot(2,1,1); plot(T, XX, 'go-'); hold on;
subplot(2,1,1); plot(T, X , 'b.-'); 
legend('ifdiff',func2str(odesolver),'Location','Best');
subplot(2,1,2); plot(T, X-XX, 'k.-');
legend('difference','Location','Best');


