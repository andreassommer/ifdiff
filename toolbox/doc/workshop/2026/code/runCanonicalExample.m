tspan = [0, 20];
y0 = [1; 0];
p = 5.437;

rhs = @rhsCanonicalExample;
integrator = @ode45;
options = odeset('RelTol', 1e-10, 'AbsTol', 1e-10);

datahandle = prepareDatahandleForIntegration(rhs, ...
    'integrator', integrator, 'options', options);

solution = solveODE(datahandle, tspan, y0, p);

t = linspace(tspan(1), tspan(end), 1000);
y = deval(solution, t);
plot(t, y);

sensitivityFunction = generateSensitivityFunction(datahandle, solution);
sensitivity = sensitivityFunction(t);

dimY = numel(y0);
dimP = numel(p);
t = [sensitivity.t];
Gy = reshape([sensitivity.Gy], dimY, dimY, []);
Gp = reshape([sensitivity.Gp], dimY, dimP, []);

figure;
tiledlayout;
for idxRow=1:dimY
    for idxCol=1:dimY
        nexttile;
        plot(t, squeeze(Gy(idxRow, idxCol, :)));
    end
end

figure;
tiledlayout;
for idxRow=1:dimY
    for idxCol=1:dimP
        nexttile;
        plot(t, squeeze(Gp(idxRow, idxCol, :)));
    end
end
