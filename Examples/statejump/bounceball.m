initPaths();

solver = @ode15s;
options    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);

g     = 9.807;
gamma = 0.9;
v0 = 10;
p = [g gamma];

t0 = 0;
tEnd = 10;
x0 = [0; v0];

datahandle = prepareDatahandleForIntegration('bounceballRHS', ...
    'solver', func2str(solver), ...
    'options', options);
sol = solveODE(datahandle, [t0 tEnd], x0, p);

T = t0:0.01:tEnd;
H = deval(sol, T, 1);
V = deval(sol, T, 2);
E = p(1)*H + (1/2) * V.^2;
plot(T, H, 'LineWidth', 2, 'DisplayName', 'h(t)');
hold on;
plotJumpingSolution(sol, [t0 tEnd], 2, {'v(t)'});
plot(T, E, 'LineWidth', 2, 'DisplayName', 'e(t)/m');