%% Setup
% Canonical Example
rhs = @canonicalExampleRHS;
tspan         = [0 20];
initialvalues = [1; 0];
parameters    = 5.437;

integrator = @ode45;
opts = odeset('AbsTol', 1e-8, 'RelTol', 1e-6);

%% Preprocess
datahandle = prepareDatahandleForIntegration(rhs, 'integrator', integrator, 'options', opts);

%% Solve
sol = solveODE(datahandle, tspan, initialvalues, parameters);
sw = sol.switches;

%% Sensitivity
dirY = [];
dirP = [];
nDirY = length(initialvalues);
nDirP = length(parameters);
t = linspace(tspan(1), tspan(2), 1000);
sens = IFDIFFSensitivity(datahandle, sol, dirY, dirP);
sens = sens.eval(t);

%% Plot
y = [];
tidx = 1;
for i=1:length(sw)+1
    if i < length(sw)+1
        tidxnew = tidx + find(t(tidx:end) >= sw(i), 1) - 1;
        ti = t(tidx:tidxnew-1);
    else
        ti = t(tidx:end);
    end
    yi = reshape(deval(sens.GySol{i}, ti), length(initialvalues), nDirY + nDirP, []);
    y = cat(3, y, yi);
    tidx = tidxnew;
end

figure;
tiledlayout(size(y, 1), size(y, 2));
for i=1:size(y, 1)
    for j=1:size(y, 2)
        nexttile
        plot(t, squeeze(y(i, j, :)));
    end
end
