%% RLC circuit with fuse

%% Setup
integrator = @ode15s;
% Parameters
R1 =    2;    % Resistor 1 (Ohm)
R2 =    5;    % Resistor 2 (Ohm)
L  =    0.1;  % Inductor (H)
C  =    0.01; % Capacitor (F)
Vsrc =  10;   % Voltage source (V)
I_threshold = 3; % Fuse parameters (where fuse blows at)

p_vec = [R1, R2, L, C, Vsrc, I_threshold];

% Initial vector, consistent as x = [i_L; v_C; i_fuse]
x0 = [0; 0; 0];
M =  [L 0 0; 0 C 0; 0 0 0];
tspan = [0 0.2];
opts = odeset('RelTol',1e-6, 'AbsTol',1e-8,'MassSingular','yes', 'Mass', M);

datahandle = prepareDatahandleForIntegration('circuitRHS', 'integrator', integrator, 'options', opts);

%% Integration
sol_circuit_ifdiff = solveODE(datahandle, tspan, x0, p_vec);
sol_test = integrator(@(t, x) circuitRHS(t, x, p_vec), tspan, x0, opts);

% Plot
Plot_test = plot(sol_test.x, sol_test.y);