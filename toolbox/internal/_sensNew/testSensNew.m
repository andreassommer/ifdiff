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
calcGy = true;
%dirY = [1, 0; 0, 1; 1, 1]';
calcGp = false;
dirP = [];
if calcGy && isempty(dirY)
    nDirY = length(initialvalues);
else
    nDirY = size(dirY, 2);
end
if calcGp && isempty(dirP)
    nDirP = length(parameters);
else
    nDirP = size(dirP, 2);
end
%t = linspace(tspan(1), tspan(2), 1000);
%t = (sol.switches(1)-0.5):0.001:(sol.switches(2)+0.5);
t = jumpLinspace(tspan(1), tspan(end), sol.switches, 1e5);
sensObj = IFDIFFSensitivity(datahandle, sol, calcGy, calcGp, dirY, dirP);
[sensT, sensSol] = sensObj.eval(t);

%% Plot directly
plotTiled(t, sensT, nDirY, nDirP)

%% Plot via sol
y = [];
tidx = 1;
for i=1:length(sw)+1
    if i < length(sw)+1
        tidxnew = tidx + find(t(tidx:end) >= sw(i), 1) - 1;
        ti = t(tidx:tidxnew-1);
    else
        ti = t(tidx:end);
    end
    yi = reshape(deval(sensSol(i), ti), length(initialvalues), nDirY + nDirP, []);
    y = cat(3, y, yi);
    tidx = tidxnew;
end
plotTiled(t, y, nDirY, nDirP)


%% Helper
function plotTiled(t, y, nDirY, nDirP)
nPrev = 0;
for nDir=[nDirY, nDirP]
    if nDir == 0
        continue
    end
    figure;
    axs = [];
    tiledlayout(size(y, 1), nDir);
    for i=1:size(y, 1)
        for j=1:nDir
            axs(i,j) = nexttile; %#ok<AGROW>
            plot(t, squeeze(y(i, nPrev + j, :)));
            title(sprintf('G_{%d%d}', i, j))
        end
    end
    ylim tight
    linkaxes(axs)
    nPrev = nDir;
end
end
