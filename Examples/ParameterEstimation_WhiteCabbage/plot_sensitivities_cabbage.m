%% Solution ifdiff
initPaths();
integrator = @ode45;
odeoptionsrhs_test = odeset( 'AbsTol', 1e-14,'RelTol', 1e-12);
datahandle    = prepareDatahandleForIntegration('whiteCabbageRHS','solver', func2str(integrator), 'options', odeoptionsrhs_test);

tspan         = [0 118];
initialvalues = [2.48252;0;0];
parameters_ODE = getParams_Cabbage();
sol = solveODE(datahandle, tspan, initialvalues, parameters_ODE);

%% Precalculations for finite differences for sensitivities
dim_y = size(sol.y, 1);
dim_p = length(parameters_ODE);
FDstep = generateFDstep(dim_y, dim_p);

%% Method for sensitivity calculations
method = 'VDE';

%% Plot sensitivities initial values 
sensitivities_function = generateSensitivityFunction(datahandle, sol, FDstep, 'calcGp', false, 'method', method, 'p_typ', parameters_ODE);
t_sens = 0:0.1:118;
sensitivites = sensitivities_function(t_sens);

%%
figure(1)
subplot(3,3,1)
hold on
for i = 1:length(t_sens)   
   plot(t_sens(i),sensitivites(i).Gy(1,1), '.b')
end
axis([0 118 0 500])
hold off
xlabel('t');
ylabel('\partial y_L(t)/\partial y_{0,L}')
title('G_{y,11}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,2)
 hold on
for i = 1:length(t_sens)
   plot(t_sens(i),sensitivites(i).Gy(1,2), '.b')  
end
axis([0 118 -1 1.5])
hold off
xlabel('t');
ylabel('\partial y_L(t)/\partial y_{0,S}')
title('G_{y,12}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,3)
hold on
for i = 1:length(t_sens)   
   plot(t_sens(i),sensitivites(i).Gy(1,3), '.b')
end
axis([0 118 -1 1.5])
hold off
xlabel('t');
ylabel('\partial y_L(t)/\partial y_{0,H}')
title('G_{y,13}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,4)
hold on
for i = 1:length(t_sens)   
   plot(t_sens(i),sensitivites(i).Gy(2,1), '.b')   
end
axis([0 118 0 500])
hold off
xlabel('t');
ylabel('\partial y_S(t)/\partial y_{0,L}')
title('G_{y,21}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,5)
 hold on
for i = 1:length(t_sens)   
   plot(t_sens(i),sensitivites(i).Gy(2,2), '.b')  
end
axis([0 118 -1 1.5])
hold off
xlabel('t');
ylabel('\partial y_S(t)/\partial y_{0,S}')
title('G_{y,22}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,6)
hold on
for i = 1:length(t_sens)   
   plot(t_sens(i),sensitivites(i).Gy(2,3), '.b')   
end
axis([0 118 -1 1.5])
hold off
xlabel('t');
ylabel('\partial y_S(t)/\partial y_{0,H}')
title('G_{y,23}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,7)
hold on
for i = 1:length(t_sens)   
   plot(t_sens(i),sensitivites(i).Gy(3,1), '.b')   
end
axis([0 118 0 500])
hold off
xlabel('t');
ylabel('\partial y_H(t)/\partial y_{0,L}')
title('G_{y,31}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,8)
hold on
for i = 1:length(t_sens)   
   plot(t_sens(i),sensitivites(i).Gy(3,2), '.b')   
end
axis([0 118 -1 1.5])
hold off
xlabel('t');
ylabel('\partial y_H(t)/\partial y_{0,S}')
title('G_{y,32}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,9)
hold on
for i = 1:length(t_sens)   
   plot(t_sens(i),sensitivites(i).Gy(3,3), '.b')   
end
axis([0 118 -1 1.5])
hold off
xlabel('t');
ylabel('\partial y_H(t)/\partial y_{0,H}')
title('G_{y,33}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

%% Plot sensitivities parameters
sensitivities_function_p = generateSensitivityFunction(datahandle, sol, FDstep, 'calcGy', false, 'method', method, 'p_typ', parameters_ODE);
t_sens = 0:0.1:118;
sensitivites = sensitivities_function_p(t_sens);

%%
figure(2)
subplot(3,3,1)
for i = 1:length(t_sens)
   axis([0 118 0 0.02])
   plot(t_sens(i),sensitivites(i).Gp(1,1), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_L(t)/\partial a')
title('G_{p,11}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,2)
for i = 1:length(t_sens)
   axis([0 118 -20 150])
   plot(t_sens(i),sensitivites(i).Gp(1,5), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_L(t)/\partial r_S')
title('G_{p,15}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,3)
for i = 1:length(t_sens)
   axis([0 118 0 4000])
   plot(t_sens(i),sensitivites(i).Gp(1,6), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_L(t)/\partial r_H')
title('G_{p,16}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,4)
for i = 1:length(t_sens)
   axis([0 118 0 0.02])
   plot(t_sens(i),sensitivites(i).Gp(2,1), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_S(t)/\partial a')
title('G_{p,21}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,5)
for i = 1:length(t_sens)
   axis([0 118 -20 150])
   plot(t_sens(i),sensitivites(i).Gp(2,5), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_S(t)/\partial r_S')
title('G_{p,25}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,6)
for i = 1:length(t_sens)
   axis([0 118 0 4000])
   plot(t_sens(i),sensitivites(i).Gp(2,6), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_S(t)/\partial r_H')
title('G_{p,26}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,7)
for i = 1:length(t_sens)
   axis([0 118 0 0.02])
   plot(t_sens(i),sensitivites(i).Gp(3,1), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_H(t)/\partial a')
title('G_{p,31}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,8)
for i = 1:length(t_sens)
   axis([0 118 -20 150])
   plot(t_sens(i),sensitivites(i).Gp(3,5), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_H(t)/\partial r_S')
title('G_{p,35}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,9)
for i = 1:length(t_sens)
   axis([0 118 0 4000])
   plot(t_sens(i),sensitivites(i).Gp(3,6), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_H(t)/\partial r_H')
title('G_{p,36}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');
