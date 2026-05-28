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
FDstep = generateFDstep(dim_y, dim_p, 'hy', 10);

%% Generation of sensitivity functions
tic;
integrator_options = odeset('AbsTol', 1e-10,'RelTol', 1e-6);
% sensitivities_function_ENDfull_DAE = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_full', 'calcGy', true,'calcGp',true, 'Gmatrices_intermediate', true, 'save_intermediates', true);
sensitivities_function_ENDpiece_DAE = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_piecewise', 'calcGy', true,'calcGp',true, 'Gmatrices_intermediate', true, 'save_intermediates', true);
sensitivities_function_VDE_DAE = generateSensitivityFunction(datahandle, sol, FDstep, 'integrator_options', integrator_options, 'method', 'VDE', 'calcGy', true,'calcGp',false, 'Gmatrices_intermediate', true, 'save_intermediates', true);
toc;

%% Sensitivty calculations


t = [4 5];
tic;
% sensitivities_full_DAE = sensitivities_function_ENDfull_DAE(t);
sensitivities_piece_DAE = sensitivities_function_ENDpiece_DAE(t);
sensitivities_VDE_DAE = sensitivities_function_VDE_DAE(t);
toc;

%{
%% Sensitivities Plots

t_plot_DAE = 0:0.01:5;
sensitivities_END_plot_DAE = sensitivities_function_ENDfull_DAE(t_plot_DAE); 

sensdata_y11_DAE = arrayfun( @(x) x.Gy(1,1), sensitivities_END_plot_DAE);
sensdata_y12_DAE = arrayfun( @(x) x.Gy(1,2), sensitivities_END_plot_DAE);
sensdata_y21_DAE = arrayfun( @(x) x.Gy(2,1), sensitivities_END_plot_DAE);
sensdata_y22_DAE = arrayfun( @(x) x.Gy(2,2), sensitivities_END_plot_DAE);


figure(1)

subplot(2,2,1)
hold on
plot(t_plot_DAE, sensdata_y11_DAE, 'b.')
axis([0 3 0 3])
hold off
xlabel('t');
ylabel('\partial y_1(t)/\partial y_{0,1}')
title('G_{y,11}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(2,2,2)
hold on
plot(t_plot_DAE, sensdata_y12_DAE, 'b.')
axis([0 3 0 3])
hold off
xlabel('t');
ylabel('\partial y_1(t)/\partial y_{0,1}')
title('G_{y,12}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(2,2,3)
hold on
plot(t_plot_DAE, sensdata_y21_DAE, 'b.')
axis([0 3 0 3])
hold off
xlabel('t');
ylabel('\partial y_2(t)/\partial y_{0,1}')
title('G_{y,21}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');


subplot(2,2,4)
hold on
plot(t_plot_DAE, sensdata_y22_DAE, 'b.')
axis([0 3 0 3])
hold off
xlabel('t');
ylabel('\partial y_2(t)/\partial y_{0,1}')
title('G_{y,22}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');
figure(1)

subplot(2,2,1)
hold on
plot(t_plot_DAE, sensdata_y11_DAE, 'b.')
axis([0 20 0 20])
hold off
xlabel('t');
ylabel('\partial y_1(t)/\partial y_{0,1}')
title('G_{y,11}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(2,2,2)
hold on
plot(t_plot_DAE, sensdata_y12_DAE, 'b.')
axis([0 20 0 20])
hold off
xlabel('t');
ylabel('\partial y_1(t)/\partial y_{0,1}')
title('G_{y,12}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(2,2,3)
hold on
plot(t_plot_DAE, sensdata_y21_DAE, 'b.')
axis([0 20 0 20])
hold off
xlabel('t');
ylabel('\partial y_2(t)/\partial y_{0,1}')
title('G_{y,21}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');


subplot(2,2,4)
hold on
plot(t_plot_DAE, sensdata_y22_DAE, 'b.')
axis([0 3 0 3])
hold off
xlabel('t');
ylabel('\partial y_2(t)/\partial y_{0,1}')
title('G_{y,22}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

%}

