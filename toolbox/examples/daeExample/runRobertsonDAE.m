y0 = [1; 0; 0];
tspan = [0 4*logspace(-6,6)];
M = [1 0 0; 0 1 0; 0 0 0];
options = odeset('Mass',M,'MassSingular', 'yes','RelTol',1e-6,'AbsTol',1e-8);
p = 0.4;

% Plain ode15s 
sol = ode15s(@(t,y) rhsRobertsonDAE(t,y,p), tspan, y0, options);
t = sol.x;
y = deval(sol, t).';
y(:,2) = 1e4 * y(:,2);

% IFDIFF
datahandle = prepareDatahandleForIntegration('rhsRobertsonDAE', 'integrator', @ode15s, 'options', options);
sol_2 = solveODE(datahandle, tspan, y0, p);

t_2 = sol_2.x;
y_2 = deval(sol_2, t_2).';
y_2(:,2) = 1e4*y_2(:,2);


%% Plot
% semilogx(t, y);
% ylabel('1e4 * y(:,2)');
% title('Robertson DAE problem with a Conservation Law, solved by ODE15S');

fig1 = figure(1);
ax = axes(fig1);
set(ax, 'XScale', 'log');
hold(ax, 'on');
plot1 = semilogx(t, y);
ylabel('1e4 * y(:,2)');
title('Robertson DAE problem with a Conservation Law (ODE15S) ');
hold(ax, 'off')

fig2 = figure(2);
ax = axes(fig2);
set(ax, 'XScale', 'log');
hold(ax, 'on');
semilogx(ax, t_2, y_2);
ylabel(ax, '1e4 * y_2(:,2)');
title(ax, 'Robertson DAE problem with a Conservation Law  (IFDIFF)');
hold(ax, 'off');