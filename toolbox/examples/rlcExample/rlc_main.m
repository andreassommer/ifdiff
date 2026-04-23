% RLC circuit with fuse
% for more details, see rlcExample_README.md

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


%% Explicit Euler (for comparison)
h = 1e-6;
sol_euler = explicitEulerDAE(@(t,x,p) rlcRHS(t,x,p), 2, tspan, x0, p, h);

%% Plots
clf;
fig1 = figure(01);

subplot(2,1,1);
hold on;
Euler_plot_1      = plot(sol_euler.x, sol_euler.y(1,:), 'go--', 'DisplayName', 'Explicit Euler');
Plot_ifdiff_1   = plot(sol_ifdiff.x, sol_ifdiff.y(1,:), 'ro--', 'DisplayName', 'IFDIFF'); 
Plot_plain_1    = plot(sol_plain.x, sol_plain.y(1,:), 'k.-', 'DisplayName', 'plain ode15s');
Switch_plot_1   = xline(sol_ifdiff.switches, 'b', 'LineWidth', 1.0, 'DisplayName', 'Switch');
ylabel('i_L (A)');
xlabel('Time (s)');
legend();
hold off;

subplot(2,1,2);
hold on;
Euler_plot_2      = plot(sol_euler.x, sol_euler.y(2,:), 'go--', 'DisplayName', 'Explicit Euler');
Plot_ifdiff_2   = plot(sol_ifdiff.x, sol_ifdiff.y(2,:), 'ro--', 'DisplayName', 'IFDIFF' );
Plot_plain_2    =  plot(sol_plain.x, sol_plain.y(2,:), 'k.-', 'DisplayName', 'plain ode15s');
ylabel('i_C (A) = i_L (A) (via constraint)');
Switch_plot_2  = xline(sol_ifdiff.switches, 'b', 'LineWidth', 1.0, 'DisplayName', 'Switch');
xlabel('Time (s)');
legend();
hold off;
