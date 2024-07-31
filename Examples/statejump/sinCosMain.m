solver = @ode45;
options = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);

t0 = 0;
tF = 10;
p = 0;
x0 = [0; 1];

datahandle = prepareDatahandleForIntegration('sinCosRHS', 'solver', func2str(solver), 'options', options);
sol = solveODE(datahandle, [t0 tF], x0, p);

T = linspace(t0, tF, 100);
X = deval(sol, T);

plot(T, X);