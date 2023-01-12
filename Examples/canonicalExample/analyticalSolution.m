%% Analytical solution
yA_1 = @(t) (1/300)*t.^3 + 1;
yA_2 = 0;
switching_function_1 = @(t) 5.437 - yA_1(t);
switch_1 = nthroot(1331.1,3);

yB_1 = @(t) 125*( (1/4)*t.^4 + (1/37500)*t.^3 - (switch_1)*t.^3 + (3/2)*(switch_1)^2*t.^2 - 1331.1*t - (1/37500)*1331.1 - (7/4)*(switch_1)^4 + 2662.2*(switch_1)) + 5.437;
yB_2 = @(t) 5*(t - switch_1);
switching_function_2 = @(t) 5.437 + 0.5 - yB_1(t);
switch_2 = fzero(switching_function_2,11);

yC_1 = @(t) (1/300)*t.^3 + yB_2(switch_2)^3*t - (1/300)*switch_2.^3 - yB_2(switch_2)^3*switch_2 + yB_1(switch_2);
yC_2 = yB_2(switch_2);
%% Plot second component of the switching function
t=10.8:0.0001:11.5;

figure(1)
plot(t,switching_function_1(t),'LineWidth', 3, 'color', 'b')
hold on
plot(t,switching_function_2(t),'LineWidth', 3, 'color', 'r')
plot(t,zeros(size(t)), 'k')
xline(switch_1, 'LineWidth', 2);
xline(switch_2, 'LineWidth', 2);
hold off
legend('\sigma_1(t)', '\sigma_2(t)')
xlabel('t')
ylabel('\sigma_2(t)')
set(gca, 'FontSize', 24);
set(gca, 'Box', 'off');
%% Solution ifdiff
initPaths();
integrator = @ode45;
odeoptionsrhs_test = odeset( 'AbsTol', 1e-14,'RelTol', 1e-12);
datahandle    = prepareDatahandleForIntegration('canonicalExampleRHS','solver', func2str(integrator), 'options', odeoptionsrhs_test);

tspan         = [0 20];
initialvalues = [1;0];
parameters    = 5.437;
sol           = solveODE(datahandle, tspan, initialvalues, parameters); 

%% Plot analytical solution vs. ifdiff

t1 = 0:0.01:switch_1;
t2 = switch_1:0.01:switch_2;
t3 = switch_2:0.01:20;

figure(2)
plot(t1,yA_1(t1), 'color', 'b','LineWidth', 3)
hold on
plot(sol.x(1:18),sol.y(1,1:18), 'o', 'color', 'r', 'MarkerSize', 8,'LineWidth', 1.5) 
plot(t2,yB_1(t2), 'color', 'b','LineWidth', 3)
plot(t3,yC_1(t3), 'color', 'b','LineWidth', 3)
plot(t1,zeros(size(t1)), 'color', 'b','LineWidth', 3)
plot(t2,yB_2(t2), 'color', 'b','LineWidth', 3)
plot(t3,yC_2*ones(size(t3)), 'color', 'b','LineWidth', 3)
plot(sol.x(19:end),sol.y(1,19:end), 'o', 'color', 'r', 'MarkerSize', 8,'LineWidth', 1.5) 
plot(sol.x,sol.y(2,:), 'o', 'color', 'r','MarkerSize', 8,'LineWidth', 1.5) 
hold off
legend('Analytical solution', 'Solution with Ifdiff')
xlabel('time [t]')
ylabel('solution [y]')
set(gca, 'FontSize', 24);
set(gca, 'Box', 'off');
%set(gca,'XTick',0:5:20);

%% Plot analytical solution vs ode45
tspan         = [0 20];
initialvalues = [1;0];
parameters    = 5.437;
canonicalExampleRHS_ode45 = @(t,y) canonicalExampleRHS(t,y,parameters);
sol_ode45 = ode45(canonicalExampleRHS_ode45, tspan, initialvalues);

t1 = 0:0.01:switch_1;
t2 = switch_1:0.01:switch_2;
t3 = switch_2:0.01:20;

figure(3)
%axis([0 20 0 20])
plot(t1,yA_1(t1), 'color', 'b','LineWidth', 3)
hold on
plot(sol_ode45.x(1:6),sol_ode45.y(1,1:6), '--', 'LineWidth', 3,'color', 'r', 'MarkerSize', 8)
plot(sol_ode45.x, 0, 'ko','lineWidth', 3, 'MarkerSize', 8);
plot(t2,yB_1(t2), 'color', 'b','LineWidth', 3)
plot(t3,yC_1(t3), 'color', 'b','LineWidth', 3)
plot(t1,zeros(size(t1)), 'color', 'b','LineWidth', 3)
plot(t2,yB_2(t2), 'color', 'b','LineWidth', 3)
plot(t3,yC_2*ones(size(t3)), 'color', 'b','LineWidth', 3)
plot(sol_ode45.x(6:end),sol_ode45.y(1,6:end), '--', 'LineWidth', 3,'color', 'r', 'MarkerSize', 8)
plot(sol_ode45.x,sol_ode45.y(2,:), '--','LineWidth', 3, 'color', 'r', 'MarkerSize', 8) 
xline(switch_1, ':', 'LineWidth', 3);
xline(switch_2, ':', 'LineWidth', 3);
plot(sol_ode45.x, 0, 'ko','lineWidth', 3, 'MarkerSize', 8);
hold off
legend('Analytical solution', 'Solution with ode45', 'Integrator steps')
%set(gca,'XTick',0:2:20); 
%set(gca,'YTick',[1 5 10 15 20 25 30]);
xlabel('time [t]')
ylabel('solution [y]')
set(gca, 'FontSize', 24);
set(gca, 'Box', 'off');

%% Plot part of analytical solution for presentation

t1 = 0:0.01:switch_1;
t2 = switch_1:0.01:switch_2;
t3 = switch_2:0.01:20;

figure(4)
axis([0 16 0 20])
plot(t1,yA_1(t1), 'color', 'b','LineWidth', 3)
hold on
axis([0 16 0 20])
plot(t2,yB_1(t2), 'color', 'b','LineWidth', 3)
plot(t3,yC_1(t3), 'color', 'b','LineWidth', 3)
plot(t1,zeros(size(t1)), 'color', 'b','LineWidth', 3)
plot(t2,yB_2(t2), 'color', 'b','LineWidth', 3)
plot(t3,yC_2*ones(size(t3)), 'color', 'b','LineWidth', 3)
xline(switch_1, ':', 'LineWidth', 3);
xline(switch_2, ':', 'LineWidth', 3);
hold off
legend('Analytical solution')
xlabel('time [t]')
ylabel('solution [y]')
set(gca, 'FontSize', 18);
set(gca, 'Box', 'off');
%set(gca,'XTick',0:5:20);