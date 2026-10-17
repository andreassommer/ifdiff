% task4.m
integrator = @ode45;
options = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);
% Initial Step erzwingen funktioniert nicht (z.B. 'InitialStep', 1e-5)

% Funktioniert nur für p=0 nicht, für p=1e-10, 1e-15, ..., 1e-30
% funktionierts aber
p = [0];

tEnd = 30;
tSpan = [0 tEnd];
x0 = [0; 1; 0];

rhs = @(t, x) swbRHS(t, x, p);
%sol_ode45 = integrator(rhs, tSpan, x0, options);
datahandle = prepareDatahandleForIntegration('swbRHS', 'integrator', integrator, 'options', options);  %% SOLVER or INTEGRATOR
sol_ifdiff = solveODE(datahandle, tSpan, x0, p);

%% Plot
T = 0:0.1:tEnd;
X = deval(sol_ifdiff, T);
plot(T, X(1,:), 'r', T, X(2,:), 'b', T, X(3,:), 'g');

%% Sensitivities
% plotSensitivities(sol, @swbRHS, p, integrator, options);
%sensFun = generateSensitivityFunction(datahandle, sol_ifdiff);
% plotSensitivitiesSwitched(sol_ifdiff, sensFun, tSpan); 
% hier wurde dieses Funktion vorher Quatsch übergeben, aber sie funktioniert trotzdem nicht
% Problem: Unrecognized field name "codeGen".