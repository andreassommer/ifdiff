function plotJumpingSolution(sol, tspan, components, legendStrings)
%PLOTSWITCHEDSOLUTION Plot the trajectory of a switched IVP solution with circles for the discontinuities.
% plot() draws a continuous line. In the case of discontinuities, this looks pretty ugly.
% inputs:
% sol           - sol object from switched IVP solving
% tspan         - time horizon
% components    - which components to plot. Does not default to 'all', you always need to pass this
% legendStrings - what to label each component. Must have the same length as components

    % Some constants. Colors will repeat after six components.
    % As for the discontinuity circles: if we draw an (empty) circle at the left limit, the end of the line
    % segment will be visible within it. To get rid of this, we also draw a white dot in the circle. Dots are
    % much smaller, so DOT_MARKER_SIZE has to be bigger. These values are the result of fiddling around until
    % I found the matching sizes.
    COLORS = {'r', 'b', 'g', 'c', 'm' 'y'};
    CIRCLE_MARKER_SIZE = 8;
    DOT_MARKER_SIZE    = 24;

    switches = sol.switches(find(sol.switches > tspan(1) & (sol.switches < tspan(end))));
    jumps    = switches(find(sol.jumps));
    if isempty(jumps)
        T = linspace(tspan(1), tspan(end), 1000);
        plot(deval(sol, T, components));
        legend(legendStrings{:});
        return;
    end
    % 1. plot a first line segment for each
    t1Minus = jumps(1) - eps(jumps(1) - eps(jumps(1)));
    T1 = linspace(tspan(1), t1Minus, 1000);
    hold on;
    plotComponents(T1, 'LineWidth', 2, 'DisplayName', legendStrings);
    leg = legend;
    leg.AutoUpdate = 'off';

    % plot remaining line segments
    for i=1 : length(jumps)-1
        t0      = jumps(i);
        tf      = jumps(i+1);
        tfMinus = tf - eps(tf - eps(tf));
        Ti = linspace(t0, tfMinus, 1000);
        plotComponents(Ti, 'LineWidth', 2);
    end

    % plot last segment (different because tf is not a switch)
    Tf = linspace(jumps(end), tspan(end), 1000);
    plotComponents(Tf, 'LineWidth', 2);

    % plot dots
    jumpsLeft = jumps - eps(jumps - eps(jumps));
    for k=1:length(components)
        plot(jumpsLeft, deval(sol, jumpsLeft, components(k)), ['o' COLORS{k}], 'MarkerSize', CIRCLE_MARKER_SIZE);
    end
    for k=1:length(components)
        plot(jumps, deval(sol, jumps, components(k)), ['.' COLORS{k}], 'MarkerSize', DOT_MARKER_SIZE);
    end
    for k=1:length(components)
        plot(jumpsLeft, deval(sol, jumpsLeft, components(k)), '.w', 'MarkerSize', DOT_MARKER_SIZE);
    end

    leg.AutoUpdate = 'on';

    function plotComponents(T, varargin)
        % Plot all components with the colors specified in colors. You can pass additional key-value pairs for
        % plot, e.g. 'LineWidth', 2. The value must be either a scalar, or a cell array with as many elements as
        % you want to plot components.
        for j=1:length(components)
            additionalOptions = {};
            for a=1:nargin/2
                key    = varargin{2*(a-1) + 1};
                values = varargin{2*a};
                if iscell(values)
                    value = values{j};
                else
                    value = values;
                end
                additionalOptions = setOption(additionalOptions, key, value);
            end
            plot(T, deval(sol, T, components(j)), COLORS{j}, additionalOptions{:});
        end
    end
end