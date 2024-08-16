function fignum = plotSensitivitiesSwitched(tGrid, sensitivities)
%PLOTSENSITIVITIESSWITCHED Given an ODE sol object and the RHS of the ODE that produced it, plot the
% sensitivities Gx of the solution w.r.t. the initial value by solving
% the VDE d/dt Gx(t) = d/dx f(t) * Gx(t); Gx(t0) = eye
% only works for sol objects generated with IFDIFF

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
            plot(tGrid, cellfun(@(x) x(r, c), Gy));
            title(sprintf('G_{y,%d,%d}', r, c));
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
            plot(tGrid, cellfun(@(x) x(r, c), Gp));
            title(sprintf('G_{p,%d,%d}', r, c));
        end
    end
end