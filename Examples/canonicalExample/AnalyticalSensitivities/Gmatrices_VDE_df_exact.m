%% Solution with ifdiff
initPaths();
integrator = @ode45;
odeoptionsrhs_test = odeset( 'AbsTol', 1e-14,'RelTol', 1e-12);
datahandle    = prepareDatahandleForIntegration('canonicalExampleRHS','solver', func2str(integrator), 'options', odeoptionsrhs_test);

tspan         = [0 20];
initialvalues = [1;0];
parameters    = 5.437;
sol           = solveODE(datahandle, tspan, initialvalues, parameters); 

%% Switching times
ts1 = nthroot(1331.1,3);

yB_1 = @(t) 125*( (1/4)*t.^4 + (1/37500)*t.^3 - (ts1)*t.^3 + (3/2)*(ts1)^2*t.^2 - 1331.1*t - (1/37500)*1331.1 - (7/4)*(ts1)^4 + 2662.2*(ts1)) + 5.437;
switching_function_2 = @(t) 5.437 + 0.5 - yB_1(t);
ts2 = fzero(switching_function_2,11);

%% Gy(ts1,t0)
% In the following we compute the G-matrices by solving the VDEs using exact derivatives of the RHS function w.r.t. y
dim_y = 2;
tspan_new = [0,ts1];
initial_y = reshape(eye(dim_y), [], 1);

solVDE = integrator(@VDE_RHS_A_y, tspan_new, initial_y, odeoptionsrhs_test);
Gy_ts1_t0 = reshape(solVDE.y(:,end), dim_y, dim_y);

%% Gy(ts2,t1)
tspan_new = [ts1,ts2];
initial_y = reshape(eye(dim_y), [], 1);

solVDE = integrator(@VDE_RHS_B_y, tspan_new, initial_y, odeoptionsrhs_test);
Gy_ts2_ts1 = reshape(solVDE.y(:,end), dim_y, dim_y);

%% Gy(tsf,t2)
tspan_new = [ts2,tspan(2)];
initial_y = reshape(eye(dim_y), [], 1);

solVDE = integrator(@VDE_RHS_C_y, tspan_new, initial_y, odeoptionsrhs_test);
Gy_tsf_ts2 = reshape(solVDE.y(:,end), dim_y, dim_y);

%% Gy(tsf,t0)

% Update matrices
U1_y = eye(2) + [0;5]*[-1 0]/((-1/100)*(nthroot(1331.1,3))^2);

dsigma_dt = @(t) -(125*t^3 + (1/100)*t^2 - 375*nthroot(1331.1,3)*t^2 + 375*(nthroot(1331.1,3))^2*t - 166387.5);
dsigma_dts2 = dsigma_dt(ts2);
U2_y = eye(2) - [0;5]*[-1 0]/dsigma_dts2;

Gy_tsf_t0 = Gy_tsf_ts2 * U2_y * Gy_ts2_ts1 * U1_y * Gy_ts1_t0;

%% Analytcal sensitivities
% Analytical solution
yA_1 = @(t) (1/300)*t.^3 + 1;
yA_2 = 0;

switch_1 = nthroot(1331.1,3);

yB_1 = @(t) 125*( (1/4)*t.^4 + (1/37500)*t.^3 - (switch_1)*t.^3 + (3/2)*(switch_1)^2*t.^2 - 1331.1*t - (1/37500)*1331.1 - (7/4)*(switch_1)^4 + 2662.2*(switch_1)) + 5.437;
yB_2 = @(t) 5*(t - switch_1);
switching_function_2 = @(t) 5.437 + 0.5 - yB_1(t);
switch_2 = fzero(switching_function_2,11);

yC_1 = @(t) (1/300)*t.^3 + yB_2(switch_2)^3*t - (1/300)*switch_2.^3 - yB_2(switch_2)^3*switch_2 + yB_1(switch_2);
yC_2 = yB_2(switch_2);

% Sensitivities with respect to the initial values

% Intermediate G-matrix G(t_s2,t_s1)
GB2_function = @(t) 25*t.^3 - (75)*nthroot(1331.1,3)*t.^2 + 75*(nthroot(1331.1,3))^2*t - 33277.5;
GB2 = GB2_function(switch_2);

% Update matrices
U1_y = eye(2) + [0;5]*[-1 0]/((-1/100)*(nthroot(1331.1,3))^2);

dsigma_dt = @(t) -(125*t^3 + (1/100)*t^2 - 375*nthroot(1331.1,3)*t^2 + 375*(nthroot(1331.1,3))^2*t - 166387.5);
dsigma_dts2 = dsigma_dt(switch_2);
U2_y = eye(2) - [0;5]*[-1 0]/dsigma_dts2;

% G(t,ts_2)
GC2_function = @(t) 3*yC_2^2*t - 3*yC_2^2*switch_2;
GC2 = GC2_function(20);

% Set up of the sensitivities for t=t_f=20
Gy_ts1_t0_analytical = eye(2);
Gy_ts2_ts1_analytical = [1 GB2; 0 1];
Gy_tf_ts2_analytical = [1 GC2; 0 1];

Gy_t_t0_analytical = Gy_tf_ts2_analytical*U2_y*Gy_ts2_ts1_analytical*U1_y*Gy_ts1_t0_analytical;

% Comparison
norm(Gy_ts1_t0- Gy_ts1_t0_analytical,inf)
norm(Gy_ts2_ts1- Gy_ts2_ts1_analytical,inf)
norm(Gy_ts2_ts1- Gy_ts2_ts1_analytical,inf)/norm(Gy_ts2_ts1_analytical,inf)
norm(Gy_tsf_ts2- Gy_tf_ts2_analytical,inf)
norm(Gy_tsf_ts2- Gy_tf_ts2_analytical,inf)/norm(Gy_tf_ts2_analytical,inf)
%norm(sensitivities_VDE.Uy{1} - U1_y,inf)
%norm(sensitivities_VDE.Uy{2} - U2_y,inf)
norm(Gy_tsf_t0 - Gy_t_t0_analytical,inf)
norm(Gy_tsf_t0 - Gy_t_t0_analytical,inf)/norm(Gy_t_t0_analytical,inf)