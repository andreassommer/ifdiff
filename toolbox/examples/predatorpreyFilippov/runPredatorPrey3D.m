%% Setup
% Time span
tspan = [0, 100];

% Integrator
intIfdiff  = @ode45;
intOptions = odeset('reltol', 1e-5, 'abstol', 1e-12);
eulerStep = 1e-5; 

% Parameter values required for Shilnikov behavior in the paper (see RHS file).
m     = 0.790;
r1    = 0.836;
e     = 0.948;
q1    = 0.772;
aq    = 0.660;
beta2 = 0.896;
% Some values changed for prettier plot (remains a Filippov system).
q2    = 1.500; % 1.084 (paper)
r2    = 0.300; % 0.126 (paper)
beta1 = 7.810; % 7.800 (Example plot in paper, but can be chosen arbitrarily, retaining Shilnikov behavior)
p = [r1, r2, beta1, beta2, q1, q2, m, e, aq];

% Initial values (used for plot in paper, but may be changed)
a  = 0.286975;
x0 = [a; a; r1-r2];

% RHS function dx = f(t, x, p), must be implemented in separate file for IFDIFF.
rhs = @rhsPredatorPrey3D;

% Plotting
plot_n = 10000;
plot_t = linspace(tspan(1), tspan(end), plot_n);

nameIfdiff = sprintf('Ifdiff/%s', func2str(intIfdiff));
nameEuler = sprintf('Euler/%.0e', eulerStep);
lwIfdiff = 3;
lwEuler = 3;
colorIfdiff = [0, 0.447, 0.741];
colorEuler = [0.85, 0.325, 0.098];
lsIfdiff = '-';
lsEuler = '--';

% Sensitivity
wrt_y = 3;
eulerDisturbH = 1e-6;


%% Solve with IFDIFF
datahandle = prepareDatahandleForIntegration(rhs, 'solver', intIfdiff, 'options', intOptions);
% Enable storing of convexification data
configNew = makeConfig();
configNew.storeSlidingInfo = true;
configOld = makeConfig(configNew);
try
    solIfdiff = solveODE(datahandle, tspan, x0, p);
catch ME
    makeConfig(configOld);
    rethrow(ME);
end
makeConfig(configOld);

%% Solve with Euler
[owndir, ~] = fileparts(mfilename('fullpath'));
if contains(owndir, 'Editor_')
    [owndir, ~] = fileparts(matlab.desktop.editor.getActiveFilename);
end

euler_prefix = sprintf('sol_euler_%.0e', eulerStep);
euler_vname = 'sol_euler';
euler_fname = fullfile(owndir, [euler_prefix, '.mat']);

solEuler = loadEulerOrCompute(euler_fname, euler_vname, rhs, tspan, x0, p, eulerStep);


%% Plot solution
plot_x_ifdiff = deval(solIfdiff, plot_t);
axSol = plotSol3d([], plot_x_ifdiff, nameIfdiff, lwIfdiff, colorIfdiff, lsIfdiff);

plot_x_euler = interp1(solEuler.x, solEuler.y', plot_t)';
plotSol3d(axSol, plot_x_euler, nameEuler, lwEuler, colorEuler, lsEuler);


%% Compute Sensitivity with IFDIFF
FDstep = generateFDstep(numel(x0), numel(p), 'hy', 1e-6, 'hp', 1e-6, 'ht', 1e-6);
sensFunVDE = generateSensitivityFunction(datahandle, solIfdiff, ...
    'method', 'VDE', ...
    'FDstep', FDstep, ...
    'calcGy', true, ...
    'calcGp', false);
sensVDE = sensFunVDE(plot_t);
G = arrayfun(@(s) s.Gy(:, wrt_y), sensVDE, 'UniformOutput', false);
plot_sens_ifdiff = [G{:}];


%% Compute Sensitivity with Euler
euler_prefix_disturb = sprintf('%s_disturb_wrt_y%d', euler_prefix, wrt_y);
euler_fname_disturb = fullfile(owndir, [euler_prefix_disturb, '.mat']);

x0_disturb = x0;
x0_disturb(wrt_y) = x0_disturb(wrt_y) + eulerDisturbH;
solEulerDisturb = loadEulerOrCompute(euler_fname_disturb, euler_vname, rhs, tspan, x0_disturb, p, eulerStep);
sensEuler = (solEulerDisturb.y - solEuler.y) / eulerDisturbH;
plot_sens_euler = interp1(solEuler.x, sensEuler', plot_t)';


%% Plot Sensitivity
for idx_y=1:3
ax = plotSens([], plot_t, plot_sens_ifdiff(idx_y, :), 'sensIFDIFF', lwIfdiff, colorIfdiff, lsIfdiff);
plotSens(ax, plot_t, plot_sens_euler(idx_y, :), 'sensEuler', lwEuler, colorEuler, lsEuler);
end


%% Plot alpha and switching function
data = datahandle.getData();
t_alpha = data.sliding.convexification.t;
alpha = data.sliding.convexification.alpha;
ax = plotSwitchingFuncOrAlpha([], t_alpha, alpha, 'Alpha', 2, colorIfdiff, 'left', 'Alpha');

sw = solIfdiff.switchingFunction{1};
sw_x = arrayfun(@(t) sw([], t, deval(solIfdiff, t), p), t_alpha);
plotSwitchingFuncOrAlpha(ax, t_alpha, sw_x, 'Switching Function', 2, colorEuler, 'right', 'Switching Function');

plotSwitches(ax, solIfdiff.switches)


%% Helpers
function sol_euler = loadEulerOrCompute(fname, vname, rhs, tspan, x0, p, step)
if isfile(fname)
    tmp = load(fname, vname);
    sol_euler = tmp.(vname);
    fprintf('Loading %s from file %s\n', vname, fname);
    return
end
fprintf('Integrating with explicit Euler (might take a while) ...\n')
sol_euler = explEuler(rhs, tspan, x0, p, step);
fprintf('Saving result to %s for later reuse.\n', fname);
save(fname, vname);
end

function plotSwitches(ax, switches)
xline(ax, switches, '--', 'LineWidth', 1.5, 'HandleVisibility', 'off');
end

function ax = plotSwitchingFuncOrAlpha(ax, t, x, name, lw, color, yyax, ylab)
if isempty(ax)
    f = figure;
    ax = axes(f);
end
yyaxis(ax, yyax);
hold(ax, 'on');
plot(ax, t, x, 'DisplayName', name, 'LineWidth', lw, 'Color', color);
hold(ax, 'off');
grid(ax, 'on');
xlabel(ax, 't');
ylabel(ax, ylab);
legend(ax, 'location', 'northeast');

yl = ylim(ax);
yl(1) = 0;
ylim(ax, yl);
end

function ax = plotSens(ax, t, x, name, lw, color, ls)
if isempty(ax)
    f = figure;
    ax = axes(f);
end
hold(ax, 'on');
plot(ax, t, x, 'DisplayName', name, 'LineWidth', lw, 'Color', color, 'LineStyle', ls);
hold(ax, 'off');
grid(ax, 'on');
xlabel(ax, 'Time')
ylabel(ax, 'Sensitivity')
legend(ax, 'location', 'northeast');
end

function ax = plotSol3d(ax, x, name, lw, color, ls)
if isempty(ax)
    f = figure;
    ax = axes(f);
end
hold(ax, 'on');
plot3(ax, x(3, :), x(2, :), x(1, :), 'DisplayName', name, 'LineWidth', lw, 'Color', color, 'LineStyle', ls);
hold(ax, 'off');

view(ax, [97 51]);
box(ax, 'on');
grid(ax, 'on');
xlabel(ax, 'Predator');
ylabel(ax, 'Prey 2');
zlabel(ax, 'Prey 1');
legend(ax, 'location', 'northeast');
end

function sol = explEuler(rhs, tspan, x0, p, stepsize)
xdim = length(x0);
stepcount = (tspan(end)-tspan(1)) / stepsize;
sfac = 0.001; % store factor
n_out = ceil(stepcount*sfac) + 1;

Xi = reshape(x0, [], 1);
X = zeros(xdim, n_out);
X(:,1) = Xi;

k = 2; nextout = ceil(1 / sfac);
for i=2:stepcount
    Xi = Xi + stepsize * rhs(i*stepsize, Xi, p);
    if (i == nextout)
        X(:,k) = Xi; k = k + 1;
        nextout = nextout + ceil(1 / sfac);
    end
    if ~mod(i, stepcount / 100), fprintf('.'); end
end
fprintf('\n');
T = linspace(tspan(1), tspan(end), n_out);
sol.x = T;
sol.y = X;
end
