%% Solution ifdiff
initPaths();
integrator = @ode45;
odeoptionsrhs_test = odeset( 'AbsTol', 1e-14,'RelTol', 1e-12);
datahandle    = prepareDatahandleForIntegration('whiteCabbageRHS','solver', func2str(integrator), 'options', odeoptionsrhs_test);

tspan         = [0 118];
initialvalues = [2.48252;0;0];
parameters_ODE = getParams_Cabbage();
sol = solveODE(datahandle, tspan, initialvalues, parameters_ODE);
%s = rng;

%% Precalculations for finite differences for sensitivities
dim_y = size(sol.y, 1);
dim_p = length(parameters_ODE);
FDstep = generateFDstep(dim_y, dim_p);

%% Generation of the measurements 
t = 0:118;
disturb = true;
sigma = 5;
%rng(s);
rand = randn(dim_y*length(t),1);
if disturb
   measurements = reshape(deval(sol, t), [], 1) + sigma.*rand;
else
   measurements = reshape(deval(sol, t), [], 1);
end

%% Generation of residual function
integrator_residual = @solveODE;
RHS = @whiteCabbageRHS;
method = 'VDE';
residual_function = generateResidualFunction(t, datahandle, sol, measurements, tspan, parameters_ODE, RHS, FDstep, integrator_residual, method);

%% Parameter estimation
options = optimoptions('lsqnonlin','SpecifyObjectiveGradient',true, 'Algorithm','levenberg-marquardt', 'Display', 'iter', 'DerivativeCheck', 'off', 'typicalX', [parameters_ODE;1;1;1]);%, 'TolX', 1e-14, 'TolFun', 1e-14);
parameters_init = [1.2*parameters_ODE; measurements(1:dim_y)];
tic;
[param_opt,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(residual_function, parameters_init, [], [], options);
toc;
percent = (param_opt*100./[getParams_Cabbage();2.48252;0;0])-100
param_opt

%% Joint confidence intervals
CI = nlparci(param_opt,residual,'jacobian',jacobian);


%% Solution with estimated parameters
initialvalues_opt = param_opt(10:12);
parameters_ODE_opt = param_opt(1:9);
sol_opt = solveODE(datahandle, tspan, initialvalues_opt, parameters_ODE_opt);

%% Plot of real solution and of solution with estimated parameters
measurements_plot = reshape(measurements, 3, []);
figure(2)
plot(sol.x, sol.y(1,:),'LineWidth', 3, 'color', [0.08,0.05,0.68]);
hold on
plot(sol_opt.x, sol_opt.y(1,:), '--', 'LineWidth', 3, 'color', [0.71,0.69,0.88]);
plot(t, measurements_plot(1,:), '*', 'MarkerSize', 5, 'color', [0.08,0.05,0.68]);
plot(sol.x, sol.y(2,:),'LineWidth', 3, 'color', [0.01,0.30,0.01]);
plot(sol_opt.x, sol_opt.y(2,:), '--', 'LineWidth', 3, 'color', [0.72,0.92,0.72]);
plot(t, measurements_plot(2,:), '*', 'MarkerSize', 5, 'color', [0.01,0.30,0.01]);
plot(sol.x, sol.y(3,:),'LineWidth', 3, 'color', [0.44,0.07,0.02]);
plot(sol_opt.x, sol_opt.y(3,:), '--', 'LineWidth', 3, 'color', [0.87,0.69,0.66]);
plot(t, measurements_plot(3,:), '*', 'MarkerSize', 5, 'color', [0.44,0.07,0.02]);
xlabel('time [t]')
ylabel('solution [y]')
set(gca, 'FontSize', 24);
set(gca, 'Box', 'off');
hold off 
legend({'$y_L(t;\tilde{p}^{\ast})$', '$y_L(t;\tilde{p}^{opt})$', 'meas. $L$', '$y_S(t;\tilde{p}^{\ast})$', '$y_S(t;\tilde{p}^{opt})$', 'meas. $S$', '$y_H(t;\tilde{p}^{\ast})$', '$y_H(t;\tilde{p}^{opt})$', 'meas. $H$'}, 'Interpreter', 'LaTeX');
