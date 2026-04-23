tspan = [0 2];
y0 = 1;
p = 0;
sol = ode23s(@(t,y) -10*t, tspan, y0);

datahandle = prepareDatahandleForIntegration('RHS', 'integrator', @ode23s);
sol_ifdiff = solveODE(datahandle, tspan, y0, p);
