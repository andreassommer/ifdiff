%% Task 3: DAEs

%Setup
tspan = [0 30];
x1_0 = 0;
x2_0 = 1000;
p = [3/4, 1/4];
M = [1 0 0; 
     0 1 0; 
     0 0 0];

% Get consistent initial conditions 
alg_eq = @(y) y.^3 + x2_0*y - p(1)*x1_0 + p(2);
y_0 = fsolve(alg_eq, 1);  % Start with initial guess y=1
fprintf('Initial conditions: x1=%.2f, x2=%.2f, y=%.6f\n', x1_0, x2_0, y_0);

%y_0 = -0.000250;
x_init = [x1_0; x2_0; y_0];

% Integration
opts = odeset('Mass', M, 'RelTol', 1e-6, 'AbsTol', 1e-8);

% naive
sol_naive = ode15s(@(t,x) rhsTask3(t, x, p), tspan, x_init, opts);

% IFDIFF
dhandle = prepareDatahandleForIntegration('rhsTask3', 'integrator', @ode15s, 'options', opts);
sol_ifdiff = solveODE(dhandle, tspan, x_init, p);


%% Plot
t_eval = tspan(1):0.0001:tspan(end);
x_naive = deval(sol_naive, t_eval);
x_ifdiff = deval(sol_ifdiff, t_eval);

fig2 = figure(02);
clf(fig2, "reset");
plot(t_eval, x_ifdiff(1,:), 'DisplayName','IFDIFF');
hold on;
plot(t_eval, x_ifdiff(2,:), 'DisplayName','IFDIFF');
hold on;
plot(t_eval, x_naive(1,:), 'DisplayName', 'ode15s');
hold on;
plot(t_eval, x_naive(2,:),  'DisplayName', 'ode15s');
hold on;
legend();
xlabel('t'); ylabel('x'); title('x vs. time'); grid on;


fig1 = figure(01);
clf(fig1, "reset")
subplot(3,1,1);
plot(t_eval, x_ifdiff(1,:));
hold on;
plot(t_eval, x_ifdiff(2,:));
hold on;
xline(sol_ifdiff.switches(1), 'b--');
xline(sol_ifdiff.switches(2), 'b--');
legend('IFDIFF');
xlabel('t'); ylabel('x'); title('IFDIFF x vs. time'); grid on;

subplot(3,1,2);
plot(t_eval, x_naive(1,:));
hold on;
plot(t_eval, x_naive(2,:));
legend('plain ode15s');
xlabel('t'); ylabel('x'); title('ode15s x vs. time'); grid on;

subplot(3,1,3);
plot(t_eval, abs(x_naive(2,:) - x_ifdiff(2,:)), 'k-');
xlabel('t'); ylabel('2nd component |x_{naive} - x_{ifdiff}|'); title('Absolute Error in x_1'); grid on;