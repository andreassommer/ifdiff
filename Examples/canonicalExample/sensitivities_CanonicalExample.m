%% Solution with ifdiff
initPaths();
integrator = @ode45;
odeoptionsrhs_test = odeset( 'AbsTol', 1e-14,'RelTol', 1e-12);
datahandle    = prepareDatahandleForIntegration('canonicalExampleRHS', 'integrator', func2str(integrator), 'options', odeoptionsrhs_test);

tspan         = [0 20];
initialvalues = [1;0];
parameters    = 5.437;
sol           = solveODE(datahandle, tspan, initialvalues, parameters); 

%% Data for finite differences
dim_y = size(sol.y, 1);
dim_p = length(parameters);
FDstep = generateFDstep(dim_y, dim_p, 'hy_rel_flag', true,'hp_rel_flag', true, 'hy_min', 1e-6, 'hp_min', 1e-6);

%% Generation of sensitivity functions
tic;
integrator_options = odeset( 'AbsTol', 1e-14,'RelTol', 1e-12);
%sensitivities_function_ENDfull = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_full', 'calcGy', true,'calcGp',true, 'Gmatrices_intermediate', true, 'save_intermediates', true);
%sensitivities_function_ENDpiece = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_piecewise', 'calcGy', true,'calcGp',true, 'Gmatrices_intermediate', true, 'save_intermediates', false);
sensitivities_function_VDE = generateSensitivityFunction(datahandle, sol, FDstep, 'integrator_options', integrator_options, 'method', 'VDE', 'calcGy', true,'calcGp',false, 'Gmatrices_intermediate', true, 'save_intermediates', false);
toc;

%% Sensitivty calculations
%t = [0:3];
%t = [20,15, 11.25, 11.26, 3, 3, 0, 20];
t = [17,18];
%t = 0:0.1:20;

tic;
%sensitivities_full = sensitivities_function_ENDfull(t);
%sensitivities_piece = sensitivities_function_ENDpiece(t);
sensitivities_VDE = sensitivities_function_VDE(t);
toc;

%% Plot sensitivities initial values
%sensitivities_function_ENDpiecewise = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_piecewise', 'Gy', true,'Gp',false, 'Gmatrices_intermediate', true, 'save_intermediates', true);
sensitivities_function_VDE = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'VDE', 'calcGy', true,'calcGp',false, 'Gmatrices_intermediate', true, 'save_intermediates', true);

t_plot = 0:0.01:20;
%sensitivities_END_plot = sensitivities_function_ENDpiecewise(t_plot);
sensitivities_END_plot = sensitivities_function_VDE(t_plot);

figure(1)
subplot(2,2,1)
for i = 1:length(t_plot)
   axis([0 20 0 20])
   plot(t_plot(i),sensitivities_END_plot(i).Gy(1,1), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_1(t)/\partial y_{0,1}')
title('G_{y,11}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(2,2,2)
for i = 1:length(t_plot)
   axis([0 20 0 20])
   plot(t_plot(i),sensitivities_END_plot(i).Gy(1,2), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_1(t)/\partial y_{0,2}')
title('G_{y,12}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(2,2,3)
for i = 1:length(t_plot)
   axis([0 20 0 20])
   plot(t_plot(i),sensitivities_END_plot(i).Gy(2,1), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_2(t)/\partial y_{0,1}')
title('G_{y,21}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(2,2,4)
for i = 1:length(t_plot)
   axis([0 20 0 20])
   plot(t_plot(i),sensitivities_END_plot(i).Gy(2,2), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_2(t)/\partial y_{0,2}')
title('G_{y,22}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

%% Plot sensitivities parameters

%sensitivities_function_ENDpiecewise = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_piecewise', 'Gy', false,'Gp',true, 'Gmatrices_intermediate', true, 'save_intermediates', true);
sensitivities_function_VDE = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'VDE', 'calcGy', false,'calcGp',true, 'Gmatrices_intermediate', true, 'save_intermediates', true);

t_plot = 0:0.01:20;
%sensitivities_END_plot = sensitivities_function_ENDpiecewise(t_plot);
sensitivities_END_plot = sensitivities_function_VDE(t_plot);

figure(2)
subplot(1,2,1)
for i = 1:length(t_plot)
   axis([0 20 -6 0])
   plot(t_plot(i),sensitivities_END_plot(i).Gp(1,1), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_1(t)/\partial p')
title('G_{p,11}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(1,2,2)
for i = 1:length(t_plot)
   axis([0 20 -6 0])
   plot(t_plot(i),sensitivities_END_plot(i).Gp(2,1), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_2(t)/\partial p')
title('G_{p,21}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');