integrator = @ode45;
options    = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);

g     = 9.807;
gamma = 0.9;
v0 = 10;
p = [g gamma];

t0 = 0;
tEnd = 10;
x0 = [0; v0];

sol = solveODE(datahandle, [t0 tEnd], x0, p);

T = t0:0.01:tEnd;
H = deval(sol, T, 1);
V = deval(sol, T, 2);
E = p(1)*H + (1/2) * V.^2;
plot(T, H, T, V, T, E);
legend('h(t)', 'v(t)', 'e(t)/m')