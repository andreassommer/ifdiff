% Initial values and parameters
tspan         = [0 20];
initialvalues = [1;0];
parameters    = 5.437;
options = odeset('MaxStep', 0.1);

dim_y = 2;
dim_p = 1;
initial_y = reshape(eye(dim_y), [], 1);
initial_p = reshape(zeros(dim_y,dim_p), [], 1);

% Solution without switching point detection with maxStep
sol = ode45(@(t,x) canonicalExampleRHS(t,x,parameters), tspan, initialvalues, options);

%% Plot sensitivities initial values VDEs without switching point detection
function_y_VDE = @(t,G) VDE_RHS_y_naiv(sol, @canonicalExampleRHS, t, G, parameters);

solVDE_y = ode45(function_y_VDE, tspan, initial_y);
t=0:0.01:20;
sensitivities_y = deval(solVDE_y, t);

figure(1)
subplot(2,2,1)
for i = 1:length(t)
%axis([0 20 0 2])
plot(t(i), sensitivities_y(1,i), '.b')
hold on 
end
xlabel('t');
ylabel('\partial y_1(t)/\partial y_0^{(1)}')
title('G_{y,11}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(2,2,2)
for i = 1:length(t)
%axis([0 20 0 50])
plot(t(i), sensitivities_y(3,i), '.b')
hold on 
end
xlabel('t');
ylabel('\partial y_1(t)/\partial y_0^{(2)}')
title('G_{y,12}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(2,2,3)
for i = 1:length(t)
axis([0 20 0 2])
plot(t(i), sensitivities_y(2,i), '.b')
hold on 
end
xlabel('t');
ylabel('\partial y_2(t)/\partial y_0^{(1)}')
title('G_{y,21}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

subplot(2,2,4)
for i = 1:length(t)
%axis([0 20 0 2])
plot(t(i), sensitivities_y(4,i), '.b')
hold on
end
xlabel('t');
ylabel('\partial y_2(t)/\partial y_0^{(2)}')
title('G_{y,22}(t; t_0)')
set(gca, 'FontSize', 22);
set(gca, 'Box', 'off');

%% Sensitivities parameters VDEs without switching point detection
function_p_VDE = @(t,G) VDE_RHS_p_naiv(sol, @canonicalExampleRHS, t, G, parameters);

solVDE_p = ode45(function_p_VDE, tspan, initial_p);
t=0:0.01:20;
sensitivities_p = deval(solVDE_p, t);



