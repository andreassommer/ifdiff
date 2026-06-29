%% Task 1 Solution e)
integrator = @ode45;

tEnd = 30;
tSpan = [0 tEnd];
p = [3/4 1/4]; 
initvals = [0; 1000];                  
  
% solution with MaxStep
options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8, 'MaxStep', 0.1);   % sets the maximum allowed step size to 0.1
sol_maxstep = ode45(@(t,x) task1RHS(t,x,p), tSpan, initvals, options);

T = 0:0.1:tEnd;
X_maxstep = deval(sol_maxstep, T);
plot(T, X_maxstep(1,:), 'b', T, X_maxstep(2,:), 'r');

%% Task 1 Sensitivities f)
plotSensitivities_odexx(sol_maxstep, @(t,x,p) task1RHS(t,x,p), p, integrator, options);