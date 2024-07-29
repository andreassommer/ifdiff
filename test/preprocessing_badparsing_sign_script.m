thoriz = [0, 5];
x0 = [1;1;1];
p = 1.0;

%rhs = @(t,x) rhs_task4(t,x,p);

opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-10);

dhandle = prepareDatahandleForIntegration('preprocessing_badparsing_sign_rhs', 'solver', 'ode45', 'options', opts)  %% SOLVER or INTEGRATOR

sol = solveODE(dhandle, thoriz, x0, p);
%sol = ode45(rhs, thoriz, x0, opts);

t = linspace(0, thoriz(2), 1000);
x = deval(sol, t);

figure(1);
plot(t,x);
legend('x1', 'x2', 'x3')

% plotSensitivitiesSwitched(dhandle, sol, p)