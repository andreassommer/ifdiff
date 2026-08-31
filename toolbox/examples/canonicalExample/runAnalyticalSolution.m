%% Config
tf = 20;
tPlotStep = 0.01;

%% Analytical solution
[solTrue, switches, switchingFunctions, t0, y0, p] = rhsAnalyticSolution;
tspan = [t0, tf];
tPlot = t0:tPlotStep:tf;

%% Plot second component of the switching function
t=10.8:0.0001:11.5;

figure
plot(t,switchingFunctions{1}(t),'LineWidth', 3, 'color', 'b')
hold on
plot(t,switchingFunctions{2}(t),'LineWidth', 3, 'color', 'r')
plot(t,zeros(size(t)), 'k')
xline(switches, 'LineWidth', 2);
hold off
legend('\sigma_1(t)', '\sigma_2(t)')
xlabel('t')
ylabel('\sigma_2(t)')
set(gca, 'FontSize', 24);
set(gca, 'Box', 'off');

%% Solution ifdiff
integrator = @ode45;
odeoptionsrhs_test = odeset( 'AbsTol', 1e-14,'RelTol', 1e-12);
datahandle    = prepareDatahandleForIntegration('rhsCanonicalExample', 'integrator', integrator, 'options', odeoptionsrhs_test);
sol           = solveODE(datahandle, tspan, y0, p);

%% Plot analytical solution vs. ifdiff
figure
hold on
h1 = plot(tPlot, solTrue(tPlot), 'color', 'b', 'LineWidth', 3, 'DisplayName', 'Analytical solution');
h2 = plot(sol.x,sol.y, 'o', 'color', 'r', 'MarkerSize', 8,'LineWidth', 1.5, 'DisplayName', 'Solution with Ifdiff');
hold off

legend([h1(1), h2(1)]);
xlabel('time [t]')
ylabel('solution [y]')
set(gca, 'FontSize', 24);
set(gca, 'Box', 'off');
%set(gca,'XTick',0:5:20);

%% Plot analytical solution vs ode45
canonicalExampleRHS_ode45 = @(t,y) rhsCanonicalExample(t,y,p);
sol_ode45 = ode45(canonicalExampleRHS_ode45, tspan, y0);

figure
%axis([0 20 0 20])
hold on
h1 = plot(tPlot, solTrue(tPlot), 'color', 'b', 'LineWidth', 3, 'DisplayName', 'Analytical solution');
h2 = plot(sol_ode45.x,sol_ode45.y, '--', 'LineWidth', 3, 'color', 'r', 'MarkerSize', 8, 'DisplayName', 'Solution with ode45');
h3 = plot(sol_ode45.x, 0, 'ko','lineWidth', 3, 'MarkerSize', 8, 'DisplayName', 'Integrator steps');
xline(switches, ':', 'LineWidth', 3);
hold off

legend([h1(1), h2(1), h3(1)]);
%set(gca,'XTick',0:2:20);
%set(gca,'YTick',[1 5 10 15 20 25 30]);
xlabel('time [t]')
ylabel('solution [y]')
set(gca, 'FontSize', 24);
set(gca, 'Box', 'off');

%% Plot part of analytical solution for presentation
figure
axis([0 16 0 20])
hold on
h1 = plot(tPlot, solTrue(tPlot), 'color', 'b', 'LineWidth', 3, 'DisplayName', 'Analytical solution');
xline(switches, ':', 'LineWidth', 3);
hold off
legend(h1(1));
xlabel('time [t]')
ylabel('solution [y]')
set(gca, 'FontSize', 18);
set(gca, 'Box', 'off');
%set(gca,'XTick',0:5:20);
