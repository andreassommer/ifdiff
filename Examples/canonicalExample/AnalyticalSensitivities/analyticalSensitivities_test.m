%% Solution ifdiff
%initPaths();
integrator = @ode45;
odeoptionsrhs_test = odeset( 'AbsTol', 1e-14,'RelTol', 1e-12);
datahandle    = prepareDatahandleForIntegration('canonicalExampleRHS','solver', func2str(integrator), 'options', odeoptionsrhs_test);

tspan         = [0 20];
initialvalues = [1;0];
parameters    = 5.437;
sol           = solveODE(datahandle, tspan, initialvalues, parameters); 

%% Precalculations for sensitivities
dim_y = size(sol.y, 1);
dim_p = length(parameters);
FDstep = generateFDstep(dim_y, dim_p, 'hy_rel_flag', true,'hp_rel_flag', true, 'hy_min', 1e-6, 'hp_min', 1e-6);

%% Sensitivities VDE
integrator_options = odeset( 'AbsTol', 1e-14,'RelTol', 1e-12);
sensitivities_function_VDE = generateSensitivityFunction(datahandle, sol, FDstep, 'integrator_options', integrator_options, 'method', 'VDE', 'Gmatrices_intermediate', true);
sensitivities_VDE = sensitivities_function_VDE(20);
%% Analytical solution
yA_1 = @(t) (1/300)*t.^3 + 1;
yA_2 = 0;

switch_1 = nthroot(1331.1,3);

yB_1 = @(t) 125*( (1/4)*t.^4 + (1/37500)*t.^3 - (switch_1)*t.^3 + (3/2)*(switch_1)^2*t.^2 - 1331.1*t - (1/37500)*1331.1 - (7/4)*(switch_1)^4 + 2662.2*(switch_1)) + 5.437;
yB_2 = @(t) 5*(t - switch_1);
switching_function_2 = @(t) 5.437 + 0.5 - yB_1(t);
switch_2 = fzero(switching_function_2,11);

yC_1 = @(t) (1/300)*t.^3 + yB_2(switch_2)^3*t - (1/300)*switch_2.^3 - yB_2(switch_2)^3*switch_2 + yB_1(switch_2);
yC_2 = yB_2(switch_2);

%% Sensitivities with respect to the initial values

% Intermediate G-matrix G(t_s2,t_s1)
GB2_function = @(t) 25*t.^3 - (75)*nthroot(1331.1,3)*t.^2 + 75*(nthroot(1331.1,3))^2*t - 33277.5;
GB2 = GB2_function(switch_2);

% Update matrices
U1_y = eye(2) + [0;5]*[-1 0]/((-1/100)*(nthroot(1331.1,3))^2);

dsigma_dt = @(t) -(125*t^3 + (1/100)*t^2 - 375*nthroot(1331.1,3)*t^2 + 375*(nthroot(1331.1,3))^2*t - 166387.5);
dsigma_dts2 = dsigma_dt(switch_2);
U2_y = eye(2) - [0;5]*[-1 0]/dsigma_dts2;

% Concluding G-matrix G(t,ts_2)
GC2_function = @(t) 3*yC_2^2*t - 3*yC_2^2*switch_2;
GC2 = GC2_function(20);

% Set up of sensitivities for t=t_f=20
Gy_ts1_t0 = eye(2);
Gy_ts2_ts1 = [1 GB2; 0 1];
Gy_tf_ts2 = [1 GC2; 0 1];

Gy_t_t0 = Gy_tf_ts2*U2_y*Gy_ts2_ts1*U1_y*Gy_ts1_t0;

% Comparison of analytical solution and solution obtained by implemented sensitivity function
norm(sensitivities_VDE.Gy_intermediate{1} - eye(2),inf)
norm(sensitivities_VDE.Gy_intermediate{1} - eye(2),inf)/norm(eye(2),inf)
norm(sensitivities_VDE.Gy_intermediate{2} - [1 GB2; 0 1],inf)
norm(sensitivities_VDE.Gy_intermediate{2} - [1 GB2; 0 1],inf)/norm([1 GB2; 0 1],inf)
norm(sensitivities_VDE.Uy{1} - U1_y,inf)
norm(sensitivities_VDE.Uy{1} - U1_y,inf)/norm(U1_y,inf)
norm(sensitivities_VDE.Uy{2} - U2_y,inf)
norm(sensitivities_VDE.Uy{2} - U2_y,inf)/norm(U2_y,inf)
norm(sensitivities_VDE.Gy - Gy_t_t0,inf)
norm(sensitivities_VDE.Gy - Gy_t_t0,inf)/norm(Gy_t_t0,inf)


%% Sensitivities with respect to the parameters

%Updates:
U1_p = [0;5]*1/((-1/100)*(nthroot(1331.1,3))^2);
U2_p = - [0;5]*1/dsigma_dts2;

%Intermediates

Gp_ts1_t0 = [0;0];
Gp_ts2_t0 = Gy_ts2_ts1 * (U1_y*Gp_ts1_t0 + U1_p) + [0;0];

%Concluding
Gp_tf_t0 = Gy_tf_ts2 * (U2_y*Gp_ts2_t0 + U2_p) + [0;0];

% Comparison
sensitivities_VDE.Gp_intermediate{1} - [0;0];
sensitivities_VDE.Gp_intermediate{2} - Gp_ts2_t0;
sensitivities_VDE.Up{1} - U1_p;
sensitivities_VDE.Up{2} - U2_p;
sensitivities_VDE.Gp - Gp_tf_t0;

