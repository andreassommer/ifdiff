integrator = @ode45;
timeinterval = [0, 100];
initstates = [1 0];
%p = 5.437;
p = 0.5;
%initPaths()
%%

options = odeset('AbsTol', 1e-14, 'RelTol', 1e-12);

filename = 'canonicalExampleRHS_extended';
clc
tic
hdlrhs_test = prepareDatahandleForIntegration(filename, 'integrator', func2str(integrator), 'options', options);
toc


%%

clc

tic
[sol_rhs_test, datanyc] = solveODE(hdlrhs_test, timeinterval, initstates, p);
toc

%%
tic
ode = ode45(@(t,x) canonicalExampleRHS_extended(t,x,p), timeinterval, initstates, options);
toc


%%
hold on
plot(sol_rhs_test.x, sol_rhs_test.y(1,:), '*r', sol_rhs_test.x, sol_rhs_test.y(2,:), '*r')
plot(ode.x, ode.y(1,:), 'k', ode.x, ode.y(2,:), 'k')
hold off





