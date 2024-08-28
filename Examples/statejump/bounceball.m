initPaths();

solver = @ode15s;
options    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);

g     = 9.807;
gamma = 0.9;
v0 = 10;
h0 = eps(1)*(1/g) * v0^2;
p = [g gamma];

t0 = 0;
tEnd = 20; % zeno begins (analytically) at 20.3935964107270316 for these particular data
x0 = [h0; v0];

datahandle = prepareDatahandleForIntegration('bounceballRHS', ...
    'solver', func2str(solver), ...
    'options', options);
sol = solveODE(datahandle, [t0 tEnd], x0, p);

T = t0:0.01:tEnd;
H = deval(sol, T, 1);
V = deval(sol, T, 2);
E = p(1)*H + (1/2) * V.^2;
plot(T, H, 'LineWidth', 2, 'DisplayName', 'h(t)', 'Color', 'blue');
hold on;
plotSolWithJumps([t0 tEnd], sol, 2, 'v(t)', 'red', struct(), 'LineWidth', 2);
plot(T, E, 'LineWidth', 2, 'DisplayName', 'e(t)/m', 'Color', [0.2 0.8 0]);