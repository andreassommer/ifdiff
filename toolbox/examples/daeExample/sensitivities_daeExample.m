%% sensitivities daeExample

%% Solution with ifdiff

integrator = @ode15s;
x0         = [1; -1];
tspan      = [0 5];
M          = [1 0; 0 0];
p          = -0.2;

opts_ifdiff = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-9,'RelTol', 1e-6);
datahandle = prepareDatahandleForIntegration('daeExampleRHS', 'integrator', integrator, 'options', opts_ifdiff);
sol = solveODE(datahandle, tspan, x0, p);

%% Data for finite differences
dim_y = size(sol.y, 1);
dim_p = length(p);
%dbstop if error
dbstop if naninf
dbstack
FDstep = generateFDstep(dim_y, dim_p, 'hy_rel_flag', true,'hp_rel_flag', true, 'hy_min', 1e-6, 'hp_min', 1e-6);

%% Generation of sensitivity functions
tic;
integrator_options = odeset( 'AbsTol', 1e-14,'RelTol', 1e-12); % generateSensitivityFunction doesn't take mass matrix options
sensitivities_function_ENDfull = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_full', 'calcGy', true,'calcGp',true, 'Gmatrices_intermediate', true, 'save_intermediates', true);
sensitivities_function_ENDpiece = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_piecewise', 'calcGy', true,'calcGp',true, 'Gmatrices_intermediate', true, 'save_intermediates', false);
sensitivities_function_VDE = generateSensitivityFunction(datahandle, sol, FDstep, 'integrator_options', integrator_options, 'method', 'VDE', 'calcGy', true,'calcGp',false, 'Gmatrices_intermediate', true, 'save_intermediates', false);
toc;

%% Sensitivty calculations
t = [0 3];
tic;
sensitivities_full = sensitivities_function_ENDfull(t);
sensitivities_piece = sensitivities_function_ENDpiece(t);
sensitivities_VDE = sensitivities_function_VDE(t);
toc;