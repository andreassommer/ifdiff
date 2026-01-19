%% RLC circuit with fuse

%% Setup
integrator = @ode15s;

p = [1; 5; 0.1; 1; 1; 0.5];
M = diag([1,1,0]);
opts = odeset('RelTol',1e-6, 'AbsTol', 1e-8,'Mass', M, 'MassSingular', 'yes');
tspan = [0 50]; 
x0 = [0; 0; 0];
[t, x] = ode15s(@(t,x) rlcRHS(t,x,p), tspan, x0, opts);


datahandle = prepareDatahandleForIntegration('rlcRHS', 'integrator', integrator, 'options', opts);

%% Integration
sol_ifdiff = solveODE(datahandle, tspan, x0, p);
sol_test = integrator(@(t, x) rlcRHS(t, x, p), tspan, x0, opts);
% Plot
clf;
fig1 = figure(01);
Plot_test = plot(sol_test.x, sol_test.y);
fig2 = figure(02);
Plot_ifdiff = plot(sol_ifdiff.x, sol_ifdiff.y);