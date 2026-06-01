%% Comparison of two formulations of stick slip vibrations using ifdiff
% The corresponding ODE can be formulated in a filippov and non-filippov
% variant and serves as a perfect example to test the accuracy of not only
% the filippov integration but also the resulting sensitivities.
%
% Both formulations of the system describe dry friction of a spring 
% suspended weight sitting on a constantly moving conveyor belt. The 
% weight moves along with the belt until spring tension becomes too high 
% and the weight is pushed back. This creates a switched periodic motion.
%
% Source: Stick-Slip Vibrations Induced by Alternate Friction Models
% paper by: R. Leine, D. van Campen, A. de Kraker, and L. van den Steen
% doi: 10.1023/A:1008289604683
%
% Both formulations can be found in "Numerical Solution of Optimal Control
% Problems with Explicit and Implicit Switches" by Andreas Meyer
% chapter: 15.3

% Solver setup
integrator = @ode15s;
optionsOde = odeset('AbsTol', 1e-10, 'RelTol', 1e-8);
optionsSens = odeset('AbsTol', 1e-10, 'RelTol', 1e-10);
% Model setup
tspan = [0, 30];
y0 = [1.133944669704; 0]; % starts in maximal value of system
%y0 = [1, 0];
k       = 1.0;      % spring constant
m       = 1.0;      % mass
v_b     = 0.2;    % velocity relative to the conveyerbelt
F_s     = 1.0;      % max static friction force
delta   = 3.0;      % Physics constant
epsilon = 1e-10;  % numerical zero parameter
p = [k, m, v_b, F_s, delta, epsilon];
dimY = length(y0);
dimP = length(p);
% Plot setup
tstep = 0.01;
tplot = tspan(1):tstep:tspan(end);
lw = 2;
fontszLabel = 12;
fontszTitle = 14;
legendSol = {'Position of Weight', 'Velocity of Weight'};
titleSol = 'ODE Solution to Friction Model';

%% Solving the friction model variant without sliding mode
noSlidingRhs = @friction_RHS_no_filippov;
warnChatteringState = warning('off', warnChatteringId);
try
    [noSlidingSol, noSlidingDatahandle, dataNoFil] = solveWithIFDIFF(noSlidingRhs, integrator, optionsOde, tspan, y0, p);
catch ME
    warning(warnChatteringState);
    rethrow(ME)
end
warning(warnChatteringState);

%% Plot solution for model without sliding mode
noSlidingYplot = deval(noSlidingSol, tplot);
noSlidingFigSol = figure;
noSlidingAxSol = axes(noSlidingFigSol);
plot(noSlidingAxSol, tplot, noSlidingYplot', 'LineWidth', lw);
setupPlotDefaults(noSlidingAxSol, noSlidingSol, 0, legendSol);
title(noSlidingAxSol, titleSol, 'FontSize', fontszTitle);

%% Compute sensitivities for model without sliding mode
fprintf('Computing sensitivity w.r.t. initial values for %s ...\n', func2str(noSlidingRhs));
FDstep = generateFDstep(dimY, dimP);
warnChatteringState = warning('off', warnChatteringId);
tStart = tic;
try
    noSlidingSensFun = generateSensitivityFunction( ...
        noSlidingDatahandle, noSlidingSol, FDstep, 'integrator_options', optionsSens);
    noSlidingSens = noSlidingSensFun(tplot);
catch ME
    warning(warnChatteringState);
    rethrow(ME)
end
tEnd = toc(tStart);
warning(warnChatteringState);
fprintf('Finished computing sensitivities. Took %.4f seconds.\n', tEnd);

%% Plot sensitivities for model without sliding mode
noSlidingFigSens = figure;
noSlidingTilesSens = tiledlayout(noSlidingFigSens, dimY, dimY);
noSlidingGy = zeros(dimY, dimY, length(tplot));
for row=1:dimY
    for col=1:dimY
        noSlidingGy(row, col, :) = arrayfun(@(x) x.Gy(row, col), noSlidingSens);
        noSlidingAxSens = nexttile(noSlidingTilesSens);
        scatter(noSlidingAxSens, tplot, squeeze(noSlidingGy(row, col, :)), ...
            'LineWidth', 0.5, 'Color', [0, 0.5, 0], 'Marker', '.');
        noSlidingSensTitle = sprintf('Gy%d%d', row, col);
        setupPlotDefaults(noSlidingAxSens, noSlidingSol, 0, {noSlidingSensTitle});
        ylabel(noSlidingAxSens, noSlidingSensTitle, 'FontSize', fontszLabel);
        title(noSlidingAxSens, noSlidingSensTitle, 'FontSize', fontszTitle);
    end
end

%% Solving the friction model variant with sliding mode
configNew = makeConfig();
configNew.storeSlidingInfo = true;
configOld = makeConfig(configNew);
slidingRhs = @friction_RHS_filippov;
warnChatteringState = warning('off', warnChatteringId);
try
    [slidingSol, slidingDatahandle, dataFil] = solveWithIFDIFF(slidingRhs, integrator, optionsOde, tspan, y0, p);
catch ME
    warning(warnChatteringState);
    rethrow(ME)
end
warning(warnChatteringState);
makeConfig(configOld);

%% Plot solution for model with sliding mode
slidingYplot = deval(slidingSol, tplot);
slidingFigSol = figure;
slidingAxSol = axes(slidingFigSol);
plot(slidingAxSol, tplot, slidingYplot', 'LineWidth', lw);
setupPlotDefaults(slidingAxSol, slidingSol, 0, legendSol);
title(slidingAxSol, [titleSol, ' (Sliding Mode)'], 'FontSize', fontszTitle);

%% Compute sensitivities for model with sliding mode
fprintf('Computing sensitivity w.r.t. initial values for %s ...\n', func2str(slidingRhs));
slidingFDstep = generateFDstep(dimY, dimP);
warnChatteringState = warning('off', warnChatteringId);
tStart = tic;
try
    slidingSensFun = generateSensitivityFunction( ...
        slidingDatahandle, slidingSol, slidingFDstep, 'integrator_options', optionsSens);
    slidingSens = slidingSensFun(tplot);
catch ME
    warning(warnChatteringState);
    rethrow(ME);
end
tEnd = toc(tStart);
warning(warnChatteringState);
fprintf('Finished computing sensitivities. Took %.4f seconds.\n', tEnd);

%% Plot sensitivities for model with sliding mode
slidingFigSens = figure;
slidingTilesSens = tiledlayout(slidingFigSens, dimY, dimY);
slidingGy = zeros(dimY, dimY, length(tplot));
for row=1:dimY
    for col=1:dimY
        slidingGy(row, col, :) = arrayfun(@(x) x.Gy(row, col), slidingSens);
        slidingAxSens = nexttile(slidingTilesSens);
        scatter(slidingAxSens, tplot, squeeze(slidingGy(row, col, :)), ...
            'LineWidth', 0.5, 'Color', [0, 0.5, 0], 'Marker', '.');
        slidingSensTitle = sprintf('Gy%d%d filippov', row, col);
        setupPlotDefaults(slidingAxSens, slidingSol, 0, {slidingSensTitle});
        ylabel(slidingAxSens, slidingSensTitle, 'FontSize', fontszLabel);
        title(slidingAxSens, slidingSensTitle, 'FontSize', fontszTitle);
    end
end

%% Plot difference in solution between models
absDiffY = abs(slidingYplot - noSlidingYplot);
figDiff = figure;
axDiff = axes(figDiff);
semilogy(axDiff, tplot, absDiffY', 'LineWidth', lw);
setupPlotDefaults(axDiff, noSlidingSol, epsilon, {'Diff Position', 'Diff Velocity'});
ylabel(axDiff, 'Absolute Difference', 'FontSize', fontszLabel);
title(axDiff, 'Difference of sliding mode and non sliding mode solutions', 'FontSize', fontszTitle);

%% Plot difference in sensitivities between models
absDiffGy = abs(slidingGy - noSlidingGy);
figDiffG = figure;
diffTilesSens = tiledlayout(figDiffG, dimY, dimY);
for row=1:dimY
    for col=1:dimY
        slidingAxDiffSens = nexttile(diffTilesSens);
        scatter(slidingAxDiffSens, tplot, squeeze(absDiffGy(row, col, :)), ...
            'LineWidth', 0.5, 'Color', [0, 0.5, 0], 'Marker', '.');
        set(slidingAxDiffSens, 'YScale', 'log');
        slidingSensTitle = sprintf('Gy%d%d difference', row, col);
        setupPlotDefaults(slidingAxDiffSens, slidingSol, 0, {slidingSensTitle});
        ylabel(slidingAxDiffSens, slidingSensTitle, 'FontSize', fontszLabel);
        title(slidingAxDiffSens, slidingSensTitle, 'FontSize', fontszTitle);
    end
end


%% Plot switching function
titleSwitchingFunction = 'Evolution of first switching condition';
v_rel = (noSlidingYplot(2,:) - v_b);
figSwitchingFunction = figure;
tilesSwitchingFunction = tiledlayout(figSwitchingFunction, 2, 1);
axSwitchingFunction = nexttile(tilesSwitchingFunction);
scatter(axSwitchingFunction, tplot, v_rel, 'LineWidth', 0.5, 'Marker', '.');
setupPlotDefaults(axSwitchingFunction, slidingSol, 0, {'\nu_{rel}'});
ylabel(axSwitchingFunction, '\nu_{rel} (switching function)', 'FontSize', fontszLabel);
title(axSwitchingFunction, titleSwitchingFunction, 'FontSize', fontszTitle);
% Zoomed in version
axSwitchingFunctionZoomed = copyobj([axSwitchingFunction, legend(axSwitchingFunction)], tilesSwitchingFunction);
axSwitchingFunctionZoomed(1).Layout.Tile = 2;
% Copy text separately due to fontsize bug
axSwitchingFunctionZoomed(1).XLabel = copyobj(axSwitchingFunction.XLabel, axSwitchingFunctionZoomed(1));
axSwitchingFunctionZoomed(1).YLabel = copyobj(axSwitchingFunction.YLabel, axSwitchingFunctionZoomed(1));
ylim(axSwitchingFunctionZoomed(1), [-2*epsilon, 2*epsilon]);
title(axSwitchingFunctionZoomed(1), [titleSwitchingFunction, ' (Zoomed)'], 'FontSize', fontszTitle);

%% Plot alpha Parameter and check against analytical parameter
t_alpha = dataFil.sliding.convexification.t;
alpha = dataFil.sliding.convexification.alpha;
figAlpha = figure;
axAlpha = axes(figAlpha);
hold(axAlpha, 'on');
% compute analytical alphas
slidingYForAlpha = deval(slidingSol, t_alpha);
x1Sliding = slidingYForAlpha(1, :);
alpha_anal = (F_s - k * x1Sliding) / (2 * F_s);
alpha_anal_defined_areas = alpha_anal;
% cut all values that are not in the regions where alpha parameter is meaningful
alpha_anal_defined_areas(alpha_anal_defined_areas > 1 | alpha_anal_defined_areas < 0 | isnan(alpha)) = NaN;
plot(axAlpha, t_alpha, alpha_anal, 'LineWidth', lw, 'Color', [0 0.8470 0.7410], 'DisplayName', 'Analytical $\alpha$ (undefined regions)','LineStyle','--');
plot(axAlpha, t_alpha, alpha_anal_defined_areas, 'LineWidth', lw+2, 'Color', [0 0.4470 0.7410], 'DisplayName', 'Analytical $\alpha$');
plot(axAlpha, t_alpha, alpha,'LineWidth', lw,'Color', [0.8500 0.9250 0.0980],'DisplayName', 'Numerical $\alpha$ (IFDIFF)');
xlabel(axAlpha, 'Time t [s]', 'Interpreter', 'latex');
ylabel(axAlpha, '$\alpha$', 'Interpreter', 'latex');
title(axAlpha, 'Comparison of Analytical and Numerical $\alpha$ (analytical in terms of numerical sol obj)','Interpreter', 'latex');
legend(axAlpha, 'Location', 'best', 'Interpreter', 'latex');
grid(axAlpha, 'on');
box(axAlpha, 'on');
set(axAlpha, 'FontSize', 12, 'LineWidth', 1);

%% Plot difference between analytical and numerical alpha
alpha_diff = alpha - alpha_anal_defined_areas;

figDiff = figure;
axDiff = axes(figDiff);
hold(axDiff, 'on');
semilogx(axDiff, t_alpha, alpha_diff, 'LineWidth', lw, 'Color', [0.6350 0.0780 0.1840],'DisplayName', '$\alpha_{\mathrm{num}} - \alpha_{\mathrm{anal}}$');
xlabel(axDiff, 'Time t [s]', 'Interpreter', 'latex');
ylabel(axDiff, '$\Delta \alpha$', 'Interpreter', 'latex');
title(axDiff, 'Difference between Numerical and Analytical $\alpha$', 'Interpreter', 'latex');
legend(axDiff, 'Location', 'best', 'Interpreter', 'latex');
grid(axDiff, 'on');
xlim(axDiff, t_alpha([1 end]));
box(axDiff, 'on');
set(axDiff, 'FontSize', 12, 'LineWidth', 1);


%% Helpers
function [sol, datahandle, data] = solveWithIFDIFF(rhs, int, opts, tspan, x0, p)
fprintf('Preprocessing %s ...\n', func2str(rhs));
datahandle = prepareDatahandleForIntegration(rhs, 'integrator', int, 'options', opts);
fprintf('Finished preprocessing, now integrating ...\n');

warnState = warning('off', warnChatteringId);
tStart = tic;
try
    sol = solveODE(datahandle, tspan, x0, p);
catch ME
    warning(warnState);
    rethrow(ME);
end
tEnd = toc(tStart);
warning(warnState);

fprintf('Finished integrating. Took %.4f seconds\n', tEnd);
data = datahandle.getData();
end

function id = warnChatteringId
id = 'IFDIFF:chattering';
end

function setupPlotDefaults(ax, sol, intStepHeight, legendEntries)
hold(ax, 'on');
box(ax, 'on');
grid(ax, 'on');

plotIntegratorSteps(ax, sol.x, intStepHeight);
plotSwitches(ax, sol.switches);

fontsz = 12;
set(ax, 'FontSize', fontsz, 'LineWidth', 1.2);
xlabel(ax, 'Time (s)', 'FontSize', fontsz);
ylabel(ax, 'States', 'FontSize', fontsz);
legend(ax, [legendEntries, {'Integrator Steps', 'Switches'}], 'Location', 'best');

hold(ax, 'off');
end

function plotIntegratorSteps(ax, t, y)
plot(ax, t, y .* ones(1, length(t)), ...
    'x', 'MarkerSize', 8, 'LineWidth', 1, 'Color', [0, 0, 0.5], 'DisplayName', 'Integrator Steps');
end

function plotSwitches(ax, t)
xline(ax, t, '--r', 'LineWidth', 1.5, 'DisplayName', 'Switches');
end