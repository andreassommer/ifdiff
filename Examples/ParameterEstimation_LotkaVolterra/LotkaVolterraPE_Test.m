%% Solution ifdiff
clear;
initPaths();
integrator = @ode45;
odeoptionsrhs_test = odeset( 'AbsTol', 1e-14,'RelTol', 1e-6);
datahandle = prepareDatahandleForIntegration('LotkaVolterraRHS', 'integrator', func2str(integrator), 'options', odeoptionsrhs_test);

tspan          = [0 120];
initialvalues  = [20; 10];
parameters_ODE = getParams_LV();
sol            = solveODE(datahandle, tspan, initialvalues, parameters_ODE);

figure(1)
plot(sol.x, sol.y(1,:),'LineWidth', 3, 'color', [0.08,0.05,0.68]);
hold on;
plot(sol.x, sol.y(2,:),'LineWidth', 3, 'color', [0.08,0.05,0.68]);

%% Precalculations for finite differences for sensitivities
dim_y  = size(sol.y, 1);
dim_p  = length(parameters_ODE);
FDstep = generateFDstep(dim_y, dim_p);

%% Generation of synthetic measurements
t            = tspan(1):tspan(end);
sigma        = 3;
rng(0);
rand         = randn(dim_y * length(t), 1);
measurements = reshape(deval(sol, t), [], 1) + sigma.*rand;

%% Generation of the residual function
integrator_residual = @solveODE;
RHS = @LotkaVolterraRHS;
method = 'VDE';
residual_function = generateResFunction(t, datahandle, sol, measurements, tspan, parameters_ODE, FDstep, method);


%% Parameter estimation
options = optimoptions('lsqnonlin','SpecifyObjectiveGradient',true, 'Algorithm','trust-region-reflective', 'Display', 'iter', 'DerivativeCheck', 'off', 'typicalX', [parameters_ODE;1;1]);
parameters_init = [1.2*parameters_ODE; measurements(1:dim_y)];
tic;
[param_opt,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(residual_function, parameters_init, zeros(6,1), [1, 1, 1, 1, 30, 30], options);
toc;
percent = (param_opt*100./[getParams_LV();20;10])-100;
disp(param_opt);

%% Solution with estimated parameters
initialvalues_opt = param_opt(5:6);
parameters_ODE_opt = param_opt(1:4);
sol_opt = solveODE(datahandle, tspan, initialvalues_opt, parameters_ODE_opt);

%% Trajectory before estimation
init_val = measurements(1:dim_y);
sol_prev = solveODE(datahandle, tspan, init_val, 1.2*parameters_ODE);
figure(40);
plot(sol_prev.x, sol_prev.y(1,:),'LineWidth', 3, 'color', [0.08,0.05,0.68]);
hold on;
plot(sol_prev.x, sol_prev.y(2,:),'LineWidth', 3, 'color', [0.08,0.05,1.00]);


%% Plot of real solution and of solution with estimated parameters
measurements_plot = reshape(measurements, 2, []);
figure(2)
plot(sol.x, sol.y(1,:),'LineWidth', 3, 'color', [0.08,0.05,0.68]);
hold on
plot(sol_opt.x, sol_opt.y(1,:), '--', 'LineWidth', 3, 'color', [0.71,0.69,0.88]);
plot(t, measurements_plot(1,:), '*', 'MarkerSize', 5, 'color', [0.08,0.05,0.68]);
plot(sol.x, sol.y(2,:),'LineWidth', 3, 'color', [0.01,0.30,0.01]);
plot(sol_opt.x, sol_opt.y(2,:), '--', 'LineWidth', 3, 'color', [0.72,0.92,0.72]);
plot(t, measurements_plot(2,:), '*', 'MarkerSize', 5, 'color', [0.01,0.30,0.01]);
xlabel('time [t]')
ylabel('solution [y]')
set(gca, 'FontSize', 12);
set(gca, 'Box', 'off');
hold off 
legend({'$y_L(t;\tilde{p}^{\ast})$', '$y_L(t;\tilde{p}^{opt})$', 'meas. $Prey$', '$y_S(t;\tilde{p}^{\ast})$', '$y_S(t;\tilde{p}^{opt})$', 'meas. $Predator$'}, 'Interpreter', 'LaTeX');
