% Configurations
integrator = @ode45;
options = odeset('MaxStep', 0.1);
dim_y         = 2;
unit          = eye(dim_y);
t_plot = 0:0.01:20;

% Initial values and parameters
initialvalues = [1;0];
tspan = [0, 20];
parameters = 5.437;

% Step size finite differences
h_FD = 1e-6;

% Solution without switching point detection with maxStep
sol = integrator(@(t,x) canonicalExampleRHS(t,x,parameters), tspan, initialvalues, options);
%% Plot of solution
% plot(sol.x, sol.y(1,:))
% hold on
% plot(sol.x, sol.y(2,:))
% hold off

%% Plot sensitivities initial values with END without switching point detection

sol_disturb_y1 = integrator(@(t,x) canonicalExampleRHS(t,x,parameters), tspan, initialvalues + h_FD*unit(:,1), options);
sol_disturb_y2 = integrator(@(t,x) canonicalExampleRHS(t,x,parameters), tspan, initialvalues + h_FD*unit(:,2), options);

y_sol_END = deval(sol,t_plot);
y1_disturb_END = deval(sol_disturb_y1,t_plot);
y2_disturb_END = deval(sol_disturb_y2,t_plot);
diff_y_y01_END = zeros(dim_y,length(t_plot));
diff_y_y02_END = zeros(dim_y,length(t_plot));

for i = 1:length(t_plot) 
   diff_y_y01_END(:,i) = (y1_disturb_END(:,i) - y_sol_END(:,i))/h_FD; 
   diff_y_y02_END(:,i) = (y2_disturb_END(:,i) - y_sol_END(:,i))/h_FD;  
end

figure(1)
subplot(2,2,1)
for i = 1:length(t_plot)
   axis([0 20 0 2])
   plot(t_plot(i),diff_y_y01_END(1,i), '.b')
   hold on
end
xlabel('t');
ylabel('\partial y_1(t)/\partial y_0^{(1)}')
title('G_{y,11}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(2,2,2)
plot(t_plot,diff_y_y02_END(1,:), '.b')
xlabel('t');
ylabel('\partial y_1(t)/\partial y_0^{(2)}')
title('G_{y,12}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(2,2,3)
for i=1:length(t_plot)
   axis([0 20 0 2])
   plot(t_plot,diff_y_y01_END(2,:), '.b')
   hold on
end
xlabel('t');
ylabel('\partial y_2(t)/\partial y_0^{(1)}')
title('G_{y,21}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(2,2,4)
plot(t_plot,diff_y_y02_END(2,:), '.b')
xlabel('t');
ylabel('\partial y_2(t)/\partial y_0^{(2)}')
title('G_{y,22}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

%% Plot sensitivities parameters without switching point detection
parameters_new = parameters + h_FD; 
sol_disturb_y1_p      = integrator(@(t,x) canonicalExampleRHS(t,x,parameters_new), tspan, initialvalues, options);
sol_disturb_y2_p      = integrator(@(t,x) canonicalExampleRHS(t,x,parameters_new), tspan, initialvalues, options);

y_sol_END_p = deval(sol,t_plot);
y1_disturb_END_p = deval(sol_disturb_y1_p,t_plot);
y2_disturb_END_p = deval(sol_disturb_y2_p,t_plot);
diff_y_p1_END = zeros(dim_y,length(t_plot));
diff_y_p2_END = zeros(dim_y,length(t_plot));

for i = 1:length(t_plot) 
   diff_y_p1_END(:,i) = (y1_disturb_END_p(:,i) - y_sol_END_p(:,i))/h_FD; 
   diff_y_p2_END(:,i) = (y2_disturb_END_p(:,i) - y_sol_END_p(:,i))/h_FD;  
end

figure(2)
subplot(1,2,1)
plot(t_plot,diff_y_p1_END(1,:), '.b')
xlabel('t');
ylabel('\partial y_1(t)/\partial p')
title('G_{p,11}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(1,2,2)
plot(t_plot,diff_y_p2_END(1,:), '.b')
xlabel('t');
ylabel('\partial y_2(t)/\partial p')
title('G_{p,21}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');
