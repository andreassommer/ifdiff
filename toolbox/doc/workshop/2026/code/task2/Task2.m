%% Task2 solution main file
% Source: Stick-Slip Vibrations Induced by Alternate Friction Models
% paper by: R. Leine, D. van Campen, A. de Kraker, and L. van den Steen
% doi: 10.1023/A:1008289604683
%
% Both formulations can be found in "Numerical Solution of Optimal Control
% Problems with Explicit and Implicit Switches" by Andreas Meyer
% chapter: 15.3

%% Solver setup
integrator = @ode45;
optionsOde = odeset('AbsTol', 1e-10, 'RelTol', 1e-8);

%% Model setup
tspan = [0, 30];
y0 = [1; 0];
k       = 1.0;      % spring constant
m       = 1.0;      % mass
v_b     = 0.2;      % velocity relative to the conveyerbelt
F_s     = 1.0;      % max static friction force
delta   = 3.0;      % Physics constant
epsilon = 1e-10;    % numerical zero parameter
p = [k, m, v_b, F_s, delta, epsilon];

%% Plot setup
tstep = 0.01;
tplot = tspan(1):tstep:tspan(end);
lw = 2;
fontszLabel = 12;
fontszTitle = 14;
legendSol = {'Position of Weight', 'Velocity of Weight'};

%% Solving the friction model variant with sliding mode
slidingRhs = @rhsTask2Fil;
slidingDatahandle = prepareDatahandleForIntegration(slidingRhs, 'integrator', integrator, 'options', optionsOde);
slidingSol = solveODE(slidingDatahandle, tspan, y0, p);

%% Plot solution for model with sliding mode
plotSolution(slidingSol, ...
    'tplot', tplot, ...
    'title', 'ODE Solution to Friction Model (Sliding Mode)', ...
    'legend', legendSol);

%% Solving the friction model variant without sliding mode
noSlidingRhs = @rhsTask2noFil;
noSlidingDatahandle = prepareDatahandleForIntegration(noSlidingRhs, 'integrator', integrator, 'options', optionsOde);
noSlidingSol = solveODE(noSlidingDatahandle, tspan, y0, p);

%% Plot solution for model without sliding mode
plotSolution(noSlidingSol, ...
    'tplot', tplot, ...
    'title', 'ODE Solution to Friction Model', ...
    'legend', legendSol);

%% Plot difference in solution between models
plotSolution(slidingSol, ...
    'reference', noSlidingSol, ...
    'tplot', tplot, ...
    'ylabel', 'Absolute Difference', ...
    'legend', {'Diff Position','Diff Velocity'}, ...
    'title', 'Difference of sliding mode and non sliding mode solutions', ...
    'intStepHeight', epsilon);

%% Helpers
function shadeFilippovIntervals(ax, sol)
    t0 = sol.x(1);
    tf = sol.x(end);
    sw = sol.switches(:);
    t_all = [t0; sw; tf];
    sig = sol.signature;
    yl = ylim(ax);
    hold(ax,'on');

    for i = 1:numel(sig)
        if isequal(size(sig{i}), [1 2]) % [1 2] if we have flippov, [1 1] otherwise
            x1 = t_all(i);
            x2 = t_all(i+1);
            h = patch(ax, [x1 x2 x2 x1], ...
                    [yl(1) yl(1) yl(2) yl(2)], ...
                    [1.0 0.5 0.0], ...
                    'FaceAlpha', 0.2, ...
                    'EdgeColor', 'none', ...
                    'HandleVisibility', 'off');
            h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        end
    end

    uistack(findall(ax,'Type','line'),'top'); % keep curves above shading
    hold(ax,'off');
end


function [fig, ax] = plotSolution(sol, varargin)

    parser = inputParser;

    addRequired(parser, 'sol');

    % collect optional params
    addParameter(parser, 'reference', []);
    addParameter(parser, 'tplot', sol.x);
    addParameter(parser, 'title', '');
    addParameter(parser, 'legend', {'State 1','State 2'});
    addParameter(parser, 'ylabel', 'States');
    addParameter(parser, 'intStepHeight', 1e-10);

    parse(parser, sol, varargin{:});

    ref = parser.Results.reference;
    tplot = parser.Results.tplot;

    % add the switching times to the evaluations 
    t_aug = unique([tplot(:); sol.switches(:)]);
    t_aug = sort(t_aug);
    if isempty(ref)
        Y = deval(sol, t_aug);
    else
        Y = abs(deval(sol,t_aug)-deval(ref,t_aug));
    end

    fig = figure;
    ax = axes(fig);

    hold(ax,'on');
    box(ax,'on');
    grid(ax,'on');

    % plot data
    hState = plot(ax, t_aug, Y', 'LineWidth', 2);
    % plot integrator steps
    hSteps = plot(ax, sol.x, ...
                    parser.Results.intStepHeight * ones(size(sol.x)), ...
                    'x', 'MarkerSize', 8, 'LineWidth', 1, ...
                    'Color', [0, 0, 0.5]);
    % plot switching times
    hSwitch = xline(ax, sol.switches, '--r', 'LineWidth', 1.5);
    % mark Flippov-Sliding regions
    shadeFilippovIntervals(ax, sol);

    fontsz = 12;
    set(ax,'FontSize',fontsz,'LineWidth',1.2);
    xlabel(ax,'Time (s)','FontSize',fontsz);
    ylabel(ax,parser.Results.ylabel,'FontSize',fontsz);
    h1 = hState(1); h2 = hState(2);
    legend(ax, [h1 h2 hSteps hSwitch(1)], [parser.Results.legend, {'Integrator Steps','Switches'}], 'Location', 'best');
    title(ax,parser.Results.title,'FontSize',14);

    % set yscale to log for difference plots
    if isempty(ref)
        yscale(ax, "linear");
    else
        yscale(ax, "log");
    end

    hold(ax,'off');
end