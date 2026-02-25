% task4.m
integrator = @ode45;
options = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);

p = 0.0001;
tEnd = 30;
tSpan = [0 tEnd];
x0 = [0; 1; 0];

% rhs = @(t, x) swbRHS(t, x, p);
% sol = integrator(rhs, tSpan, x0, options);
datahandle = prepareDatahandleForIntegration('swbRHS', 'integrator', integrator, 'options', options);  %% SOLVER or INTEGRATOR
sol = solveODE(datahandle, tSpan, x0, p);

T = 0:0.1:tEnd;
X = deval(sol, T);
plot(T, X(1,:), 'r', T, X(2,:), 'b', T, X(3,:), 'g');

% plotSensitivities(sol, @swbRHS, p, integrator, options);
plotSensitivitiesSwitched(datahandle, sol, p);