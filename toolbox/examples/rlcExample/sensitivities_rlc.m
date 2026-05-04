%% RLC Sensitivities

%% Setup and integration
integrator = @ode15s;
M          = diag([1,1,0]);
x0         = [0; 0; 0];
tspan      = [0 5]; 

L   = 1.0;
R1  = 5.0;
R2  = 0.1;
C   = 1.0;
Vs  = 1.0;
Vth = 0.5;
p   = [L; R1; R2; C; Vs; Vth];

opts_ifdiff = odeset('Mass', M,'AbsTol', 1e-8, 'RelTol', 1e-5);
opts_plain  = odeset('Mass', M,'AbsTol', 1e-8, 'RelTol', 1e-5);

datahandle = prepareDatahandleForIntegration('rlcRHS', 'integrator', integrator, 'options', opts_ifdiff);

sol_ifdiff = solveODE(datahandle, tspan, x0, p);
sol_plain  = integrator(@(t, x) rlcRHS(t, x, p), tspan, x0, opts_plain);

%% Data for finite differences
dim_y = size(sol.y, 1);
dim_p = length(p);
FDstep = generateFDstep(dim_y, dim_p, 'hy_rel_flag', true,'hp_rel_flag', true, 'hy_min', 1e-3, 'hp_min', 1e-3);

%% Generation of sensitivity functions
tic;
integrator_options = odeset('AbsTol', 1e-14,'RelTol', 1e-12, 'MassSingular','no');
sensitivities_function_ENDfull_DAE = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_full', 'calcGy', true,'calcGp',true, 'Gmatrices_intermediate', true, 'save_intermediates', true);
sensitivities_function_ENDpiece_DAE = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_piecewise', 'calcGy', true,'calcGp',true, 'Gmatrices_intermediate', true, 'save_intermediates', false);
sensitivities_function_VDE_DAE = generateSensitivityFunction(datahandle, sol, FDstep, 'integrator_options', integrator_options, 'method', 'VDE', 'calcGy', true,'calcGp',false, 'Gmatrices_intermediate', true, 'save_intermediates', false);
toc;

%% Sensitivty calculations
t = [0 5];
tic;
sensitivities_full_DAE = sensitivities_function_ENDfull_DAE(t);
sensitivities_piece_DAE = sensitivities_function_ENDpiece_DAE(t);
sensitivities_VDE_DAE = sensitivities_function_VDE_DAE(t);
toc;