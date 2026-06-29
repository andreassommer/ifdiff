%% Task 1 Solution a)
integrator = @ode45;

tEnd = 30;
tSpan = [0 tEnd];
p = [3/4 1/4]; 
initvals = [0; 1000];                  
  
% solution with ode45 (not designed for switched problems)
options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
sol_ode45 = ode45(@(t,x) task1RHS(t,x,p), tSpan, initvals, options);

T = 0:0.1:tEnd;
X_ode45 = deval(sol_ode45, T);
plot(T, X_ode45(1,:), 'b', T, X_ode45(2,:), 'r');

%% Task 1 Sensitivities b)
plotSensitivities_odexx(sol_ode45, @(t,x,p) task1RHS(t,x,p), p, integrator, options);