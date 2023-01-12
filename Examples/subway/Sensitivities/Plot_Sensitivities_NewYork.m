%% Solution ifdiff and ode45
integrator = @ode45;
tspan      = [0.0, 65.0];
initValues = [0.0, 0.0, 0.0].';
parameters = nysscc_getPhysicsParameters_vector();
odeoptionssubwaymodel = odeset( 'AbsTol', 1e-20, 'RelTol', 1e-10);

datahandle = prepareDatahandleForIntegration('newYorkCitySubwayModelRhs_wrapped', 'solver', func2str(integrator), 'options', odeoptionssubwaymodel);
sol = solveODE(datahandle, tspan, initValues, parameters);

sol_ode45 = ode45(@(t,x) newYorkCitySubwayModelRhs(t,x, nysscc_getPhysicsParameters()),tspan, initValues,odeoptionssubwaymodel);
%% Plot solution ifdiff and ode45

figure(1)
plot(sol.x, sol.y(1,:),'LineWidth', 4, 'color', 'b')
hold on
plot(sol_ode45.x, sol_ode45.y(1,:),'o', 'color', 'r', 'MarkerSize', 8,'LineWidth', 1.5)
for i=1:length(sol.switches)
   xline(sol.switches(i), '--', 'LineWidth', 2)
end
hold off
legend('Solution with ifdiff', 'Solution with ode45')
xlabel('time [t]')
ylabel('distance [ft]')
set(gca, 'FontSize', 26);
set(gca, 'Box', 'off');


figure(2)
plot(sol.x, sol.y(2,:),'LineWidth', 4, 'color', 'b')
hold on
plot(sol_ode45.x, sol_ode45.y(2,:),'o', 'color', 'r', 'MarkerSize', 8,'LineWidth', 1.5)
for i=1:length(sol.switches)
   xline(sol.switches(i), '--', 'LineWidth', 2)
end
hold off
legend('Solution with ifdiff', 'Solution with ode45')
xlabel('time [t]')
ylabel('speed [ft/s]')
set(gca, 'FontSize', 26);
set(gca, 'Box', 'off');

figure(3)
plot(sol.x, sol.y(3,:),'LineWidth', 4, 'color', 'b')
hold on
plot(sol_ode45.x, sol_ode45.y(3,:),'o', 'color', 'r', 'MarkerSize', 8,'LineWidth', 1.5)
for i=1:length(sol.switches)
   xline(sol.switches(i), '--', 'LineWidth', 2)
end
hold off
legend('Solution with ifdiff', 'Solution with ode45')
xlabel('time [t]')
ylabel('energy [Wh]')
set(gca, 'FontSize', 26);
set(gca, 'Box', 'off');


%% Precalculations for Sensitivities 
dim_y = size(sol.y, 1);
dim_p = length(parameters);
FDstep = generateFDstep(dim_y, dim_p);

sensitivities_function_END = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_piecewise', 'calcGy', true, 'calcGp', false, 'Gmatrices_intermediate', false, 'save_intermediates', true);
%sensitivities_function_VDE = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'VDE', 'Gy', true, 'Gp', false, 'Gmatrices_intermediate', false, 'save_intermediates', true, 'directions_p', eye(46,5));


%% Plot sensitivities initial values
t_sens = 0:0.1:65;
sensitivites = sensitivities_function_END(t_sens);
%sensitivites = sensitivities_function_VDE(t_sens);
%%
figure(4)
subplot(3,3,1)
for i = 1:length(t_sens)
   axis([0 65 0 2])
   plot(t_sens(i),sensitivites(i).Gy(1,1), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_1(t)/\partial y_{0,1}')
title('G_{y,11}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,2)
for i = 1:length(t_sens)
   axis([0 65 0 22])
   plot(t_sens(i),sensitivites(i).Gy(1,2), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_1(t)/\partial y_{0,2}')
title('G_{y,12}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,3)
for i = 1:length(t_sens)
   axis([0 65 0 2])
   plot(t_sens(i),sensitivites(i).Gy(1,3), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_1(t)/\partial y_{0,3}')
title('G_{y,13}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,4)
for i = 1:length(t_sens)
   axis([0 65 0 2])
   plot(t_sens(i),sensitivites(i).Gy(2,1), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_2(t)/\partial y_{0,1}')
title('G_{y,21}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,5)
for i = 1:length(t_sens)
   axis([0 65 0 2.5])
   plot(t_sens(i),sensitivites(i).Gy(2,2), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_2(t)/\partial y_{0,2}')
title('G_{y,22}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,6)
for i = 1:length(t_sens)
   axis([0 65 0 2])
   plot(t_sens(i),sensitivites(i).Gy(2,3), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_2(t)/\partial y_{0,3}')
title('G_{y,23}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');
subplot(3,3,7)
for i = 1:length(t_sens)
   axis([0 65 0 2])
   plot(t_sens(i),sensitivites(i).Gy(3,1), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_3(t)/\partial y_{0,1}')
title('G_{y,31}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,8)
for i = 1:length(t_sens)
   axis([0 65 -50 60])
   plot(t_sens(i),sensitivites(i).Gy(3,2), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_3(t)/\partial y_{0,2}')
title('G_{y,32}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');


subplot(3,3,9)
for i = 1:length(t_sens)
   axis([0 65 0 2])
   plot(t_sens(i),sensitivites(i).Gy(3,3), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_3(t)/\partial y_{0,3}')
title('G_{y,33}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

%% Plot sensitivities END with ode45 without switching point detection

% Settings
integrator = @ode45;
odeoptionssubwaymodel = odeset( 'AbsTol', 1e-20, 'RelTol', 1e-10); %, 'MaxStep', 0.01);
%options = odeset('MaxStep', 0.01);
dim_y         = 3;
unit          = eye(dim_y);
t_plot = 0:0.1:65;

% Initial values and parameters
tspan      = [0.0, 65.0];
initValues = [0.0, 0.0, 0.0].';
parameters = nysscc_getPhysicsParameters_vector();

% step size finite differences
h_FD = 1e-6;

sol = integrator(@(t,x) newYorkCitySubwayModelRhs_wrapped(t,x,parameters), tspan, initValues, odeoptionssubwaymodel);

sol_disturb_y1 = integrator(@(t,x) newYorkCitySubwayModelRhs_wrapped(t,x,parameters), tspan, initValues + h_FD*unit(:,1), odeoptionssubwaymodel);
sol_disturb_y2 = integrator(@(t,x) newYorkCitySubwayModelRhs_wrapped(t,x,parameters), tspan, initValues + h_FD*unit(:,2), odeoptionssubwaymodel);
sol_disturb_y3 = integrator(@(t,x) newYorkCitySubwayModelRhs_wrapped(t,x,parameters), tspan, initValues + h_FD*unit(:,3), odeoptionssubwaymodel);

y_sol_END = deval(sol,t_plot);
y1_disturb_END = deval(sol_disturb_y1,t_plot);
y2_disturb_END = deval(sol_disturb_y2,t_plot);
y3_disturb_END = deval(sol_disturb_y3,t_plot);

diff_y_y01_END = zeros(dim_y,length(t_plot));
diff_y_y02_END = zeros(dim_y,length(t_plot));
diff_y_y03_END = zeros(dim_y,length(t_plot));

for i = 1:length(t_plot) 
   diff_y_y01_END(:,i) = (y1_disturb_END(:,i) - y_sol_END(:,i))/h_FD; 
   diff_y_y02_END(:,i) = (y2_disturb_END(:,i) - y_sol_END(:,i))/h_FD;  
   diff_y_y03_END(:,i) = (y3_disturb_END(:,i) - y_sol_END(:,i))/h_FD;  
end

figure(5)
subplot(3,3,1)
for i = 1:length(t_plot)
   axis([0 65 -1 2.5])
   plot(t_plot(i),diff_y_y01_END(1,i), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_1(t)/\partial y_{0,1}')
title('G_{y,11}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,2)
for i = 1:length(t_plot)
   axis([0 65 0 22])
   plot(t_plot(i),diff_y_y02_END(1,i), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_1(t)/\partial y_{0,2}')
title('G_{y,12}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,3)
for i = 1:length(t_plot)
   axis([0 65 -10 5])
   plot(t_plot(i),diff_y_y03_END(1,i), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_1(t)/\partial y_{0,3}')
title('G_{y,13}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,4)
for i = 1:length(t_plot)
   axis([0 65 -0.2 0.25])
   plot(t_plot(i),diff_y_y01_END(2,i), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_2(t)/\partial y_{0,1}')
title('G_{y,21}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,5)
for i = 1:length(t_plot)
   axis([0 65 0 2.5])
   plot(t_plot(i),diff_y_y02_END(2,i), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_2(t)/\partial y_{0,2}')
title('G_{y,22}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,6)
for i = 1:length(t_plot)
   axis([0 65 -0.5 0.5])
   plot(t_plot(i),diff_y_y03_END(2,i), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_2(t)/\partial y_{0,3}')
title('G_{y,23}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');
subplot(3,3,7)
for i = 1:length(t_plot)
   axis([0 65 -10 5.5])
   plot(t_plot(i),diff_y_y01_END(3,i), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_3(t)/\partial y_{0,1}')
title('G_{y,31}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(3,3,8)
for i = 1:length(t_plot)
   axis([0 65 -50 60])
   plot(t_plot(i),diff_y_y02_END(3,i), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_3(t)/\partial y_{0,2}')
title('G_{y,32}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');


subplot(3,3,9)
for i = 1:length(t_plot)
   axis([0 65 -20 5])
   plot(t_plot(i),diff_y_y03_END(3,i), '.b')
   hold on
end
hold off
xlabel('t');
ylabel('\partial y_3(t)/\partial y_{0,3}')
title('G_{y,33}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');





% 
% 
% subplot(3,3,1)
% plot(t_plot,diff_y_y01_END(1,:), '.b')
% xlabel('t');
% ylabel('\partial y_1(t)/\partial y_0^{(1)}')
% title('G_{y,11}(t; t_0)')
% set(gca, 'FontSize', 22);
% set(gca, 'Box', 'off');
% 
% subplot(3,3,2)
% plot(t_plot,diff_y_y02_END(1,:), '.b')
% xlabel('t');
% ylabel('\partial y_1(t)/\partial y_0^{(2)}')
% title('G_{y,12}(t; t_0)')
% set(gca, 'FontSize', 22);
% set(gca, 'Box', 'off');
% 
% subplot(3,3,3)
% plot(t_plot,diff_y_y03_END(1,:), '.b')
% xlabel('t');
% ylabel('\partial y_1(t)/\partial y_0^{(3)}')
% title('G_{y,13}(t; t_0)')
% set(gca, 'FontSize', 22);
% set(gca, 'Box', 'off');
% 
% subplot(3,3,4)
% plot(t_plot,diff_y_y01_END(2,:), '.b')
% xlabel('t');
% ylabel('\partial y_2(t)/\partial y_0^{(1)}')
% title('G_{y,21}(t; t_0)')
% set(gca, 'FontSize', 22);
% set(gca, 'Box', 'off');
% 
% subplot(3,3,5)
% plot(t_plot,diff_y_y02_END(2,:), '.b')
% xlabel('t');
% ylabel('\partial y_2(t)/\partial y_0^{(2)}')
% title('G_{y,22}(t; t_0)')
% set(gca, 'FontSize', 22);
% set(gca, 'Box', 'off');
% 
% subplot(3,3,6)
% plot(t_plot,diff_y_y03_END(2,:), '.b')
% xlabel('t');
% ylabel('\partial y_2(t)/\partial y_0^{(3)}')
% title('G_{y,23}(t; t_0)')
% set(gca, 'FontSize', 22);
% set(gca, 'Box', 'off');
% 
% subplot(3,3,7)
% plot(t_plot,diff_y_y01_END(3,:), '.b')
% xlabel('t');
% ylabel('\partial y_3(t)/\partial y_0^{(1)}')
% title('G_{y,31}(t; t_0)')
% set(gca, 'FontSize', 22);
% set(gca, 'Box', 'off');
% 
% subplot(3,3,8)
% plot(t_plot,diff_y_y02_END(3,:), '.b')
% xlabel('t');
% ylabel('\partial y_3(t)/\partial y_0^{(2)}')
% title('G_{y,32}(t; t_0)')
% set(gca, 'FontSize', 22);
% set(gca, 'Box', 'off');
% 
% subplot(3,3,9)
% plot(t_plot,diff_y_y03_END(3,:), '.b')
% xlabel('t');
% ylabel('\partial y_3(t)/\partial y_0^{(3)}')
% title('G_{y,33}(t; t_0)')
% set(gca, 'FontSize', 22);
% set(gca, 'Box', 'off');
% 
% %Skalierung der Achsen fehlt!!!