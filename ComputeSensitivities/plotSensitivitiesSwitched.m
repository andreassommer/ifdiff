function fignum = plotSensitivitiesSwitched(sol, sensFun, tspan)
%PLOTSENSITIVITIESSWITCHED plot sensitivities Gy and Gp
% plotSensitivitiesSwitches(sol, sensitivities, T)
%
% Create a new figure window. For every entry in Gx, create a plot in this window showing that entry. If the solution
% has n entries, then that translates to n*n plots. If the sensitivities contain Gp as well, then create a second
% figure window with an analogous number of plots for Gp.
%
% Arguments:
% sol: IFDIFF ODE solution structure
% sensFun: sensitivity function produced by generateSensitivityFunction
% tspan: time horizon
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
            plotPointsWithJumps(T, cellfun(@(x) x(r, c), Gy), jumps, sprintf('G_{y,%d,%d}', r, c), [0.7 0.4 0], struct(), 'LineWidth', 2);
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
            plotPointsWithJumps(T, cellfun(@(x) x(r, c), Gp), jumps, sprintf('G_{p,%d,%d}', r, c), [0.7 0 0.4], struct(), 'LineWidth', 2);
        end
    end
end