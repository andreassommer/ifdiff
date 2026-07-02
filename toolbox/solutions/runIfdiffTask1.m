%% Task 1 Solution c)
integrator = @ode45;

tEnd = 30;
tSpan = [0 tEnd];
p = [3/4 1/4]; 
initvals = [0; 1000];                  
options = odeset('AbsTol', 1e-8, 'RelTol',1e-6);

% solution with ifdiff
datahandle = prepareDatahandleForIntegration('rhsTask1', ...
    'integrator', integrator, ...
    'options', options);
sol_ifdiff = solveODE(datahandle, tSpan, initvals, p);

T = 0:0.1:tEnd;
X_ifdiff = deval(sol_ifdiff, T);
plot(T, X_ifdiff(1,:), 'b', T, X_ifdiff(2,:), 'r');

%% Task 1 Sensitivities d)
plotSensitivities_ifdiff(datahandle, sol_ifdiff, p);