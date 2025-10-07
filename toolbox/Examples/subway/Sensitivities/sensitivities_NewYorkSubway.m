%% Solution with ifdiff
integrator = @ode45;
tspan      = [0.0, 65.0];
initValues = [0.0, 0.0, 0.0].';
parameters = nysscc_getPhysicsParameters_vector();
odeoptionssubwaymodel = odeset( 'AbsTol', 1e-20, 'RelTol', 1e-10);

datahandle = prepareDatahandleForIntegration('newYorkCitySubwayModelRhs_wrapped', 'integrator', func2str(integrator), 'options', odeoptionssubwaymodel);
sol = solveODE(datahandle, tspan, initValues, parameters);

%% Precalculations for sensitivities

% Data for finite differences
dim_y = size(sol.y, 1);
dim_p = length(parameters);
FDstep = generateFDstep(dim_y, dim_p, 'hy_rel_flag', false, 'hp_rel_flag', false);

% Generation of sensitivity functions
tic;
sensitivities_function_END = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_piecewise', 'calcGy', true, 'calcGp', false, 'Gmatrices_intermediate', false, 'save_intermediates', false);
sensitivities_function_VDE = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'VDE', 'calcGy', true, 'calcGp', false, 'Gmatrices_intermediate', false, 'save_intermediates', true, 'directions_p', eye(46,5));
toc;
%% Sensitivity calculations
t = [0; 15; 17; 20; sol.switches(1)];
%t = sol.switches(1);
%t = [1 5 40 3];
%t = 0:65;

tic;
sensitivities_END = sensitivities_function_END(t);
sensitivities_VDE = sensitivities_function_VDE(t);
toc

