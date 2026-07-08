tspan = [0, 5];
y0 = [1; 0];
p = [];

rhs = @rhsBounceball;
datahandle = prepareDatahandleForIntegration(rhs);

solution = solveODE(datahandle, tspan, y0, p);

t = linspace(tspan(1), tspan(end), 1000);
y = deval(solution, t);
plot(t, y);
