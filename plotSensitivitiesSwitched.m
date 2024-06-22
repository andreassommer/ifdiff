function fignum = plotSensitivitiesSwitched(datahandle, sol, parameters)
%PLOTSENSITIVITIESSWITCHED Given an ODE sol object and the RHS of the ODE that produced it, plot the
% sensitivities Gx of the solution w.r.t. the initial value by solving
% the VDE d/dt Gx(t) = d/dx f(t) * Gx(t); Gx(t0) = eye
% only works for sol objects generated with IFDIFF

    yDim = size(sol.y, 1);
    pDim = length(parameters);
    FDstep = generateFDstep(yDim, pDim, 'y_typ', max(sol.y, [], 2));

    sensFun = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'VDE');
    tGrid = linspace(sol.x(1), sol.x(end), 1000);
    sensitivities = sensFun(tGrid);

    fignum = 5678;
    fig = figure(fignum);
    % shift a little so it doesn't exactly cover the solution plot's window
    fig.Position = fig.Position + [32, -32, 0, 0];

    for r=1:yDim
        for c=1:yDim
            % the VDE solution was reshaped to column-major order, while subplot goes row-major.
            subplot(yDim, yDim, (r-1)*yDim + c);
            Gx = {sensitivities.Gy};
            plot(tGrid, cellfun(@(x) x(r, c), Gx));
            title(sprintf('G_{y,%d,%d}', r, c));
        end
    end
end