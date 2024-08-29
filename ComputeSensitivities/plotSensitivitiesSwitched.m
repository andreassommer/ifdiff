function fignum = plotSensitivitiesSwitched(sol, sensFun, tspan, varargin)
%PLOTSENSITIVITIESSWITCHED plot sensitivities Gy and Gp
% plotSensitivitiesSwitches(sol, sensitivities, T)
% plotSensitivitiesSwitches(sol, sensitivities, T, optionsGy, optionsGp)
% plotSensitivitiesSwitches(sol, sensitivities, T, optionsGy, optionsGp, Key1, Value1, ..., KeyN, ValueN)
%
% Create a new figure window. For every entry in Gx, create a plot in this window showing that entry. If the solution
% has n entries, then that translates to n*n plots. If the sensitivities contain Gp as well, then create a second
% figure window with an analogous number of plots for Gp.
%
% Arguments:
% sol: IFDIFF ODE solution structure
% sensFun: sensitivity function produced by generateSensitivityFunction
% tspan: time horizon
% optionsGy: options to pass to plotPointsWithJumps for Gy (see plotPointsWithJumps)
% optionsGp: options to pass to plotPointsWithJumps for Gp (see plotPointsWithJumps)
% KeyI, ValueI: additional options that will be passed to the plot() commands for the line segments.
%     if ValueI is scalar, both Gp and Gy get the argument with that value. If it is a cell array, the first
%     element is passed to Gy and the second to Gp. If either is empty, it is ignored. Example:
%     'LineWidth', 2 - draw both Gy and Gp with line width 2
%     'LineWidth', {2, 3} - draw Gy with line width 2 and Gp with line width 3
%     'LineWidth', {'', 3} - draw Gp with line width 3 and Gy with no 'LineWidth' parameter

    if nargin >= 4
        optionsGy = varargin{1};
    else
        optionsGy = struct();
    end
    if nargin >= 5
        optionsGp = varargin{2};
    else
        optionsGp = struct();
    end
    plotOptionsGy = {};
    plotOptionsGp = {};
    nPairs = floor((nargin - 5) / 2);
    for i=1:nPairs
        key   = varargin{3 + (i-1)*2};
        value = varargin{4 + (i-1)*2};
        if ~iscell(value) || length(value) == 1
            plotOptionsGy = [plotOptionsGy key value];
            plotOptionsGp = [plotOptionsGp key value];
        else
            if ~isempty(value{1})
                plotOptionsGy = [plotOptionsGy key value{1}];
            end
            if ~isempty(value{2})
                plotOptionsGp = [plotOptionsGp key value{2}];
            end
        end
    end

    % Get the sensitivity values
    jumps = sol.switches(find(sol.jumps));
    T = jumpLinspace(tspan(1), tspan(2), jumps, 1000);
    sensitivities = sensFun(T);
    Gy = {sensitivities.Gy};

    if isempty(Gy) || isempty(Gy{1})
        return;
    end
    yDim = length(Gy{1});

    fignum = 1234;
    fig = figure(fignum);
    % shift a little so it doesn't exactly cover the solution plot's window
    fig.Position = fig.Position + [32, -32, 0, 0];

    for r=1:yDim
        for c=1:yDim
            % the VDE solution was reshaped to column-major order, while subplot goes row-major.
            subplot(yDim, yDim, (r-1)*yDim + c);
            Gy_rc = cellfun(@(x) x(r, c), Gy);
            Gy_label = sprintf('G_{y,%d,%d}', r, c);
            plotPointsWithJumps(T, Gy_rc, jumps, Gy_label, [0.8 0.4 0], optionsGy, plotOptionsGy{:});
        end
    end

    Gp = {sensitivities.Gp};
    if isempty(Gp) || isempty(Gp{1})
        return;
    end
    pDim = size(Gp{1}, 2);

    fignum = 5678;
    fig = figure(fignum);
    % shift a little so it doesn't exactly cover the solution plot's window
    fig.Position = fig.Position + [32, -32, 0, 0];

    for r=1:yDim
        for c=1:pDim
            % the VDE solution was reshaped to column-major order, while subplot goes row-major.
            subplot(yDim, pDim, (r-1)*yDim + c);
            Gp_rc = cellfun(@(x) x(r, c), Gp);
            Gp_label = sprintf('G_{p,%d,%d}', r, c);
            plotPointsWithJumps(T, Gp_rc, jumps, Gp_label, [0.7 0 0.4], optionsGp, plotOptionsGp{:});
        end
    end
end