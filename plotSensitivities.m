function fignum = plotSensitivities(sol, rhs, parameters, integrator, integratorOptions)
%PLOTSENSITIVITIES Given an ODE sol object and the RHS of the ODE that produced it, plot the sensitivities Gx
% of the solution w.r.t. the initial value by solving the VDE d/dt Gx(t) = d/dx f(t) * Gx(t); Gx(t0) = eye
% does not work for sol objects generated with IFDIFF

    yDim = size(sol.y, 1);
    pDim = length(parameters);
    vdeOptions = struct('FDstep', generateFDstep(yDim, pDim));

    vdeRhs = @(t,G) VDE_RHS_y(sol, rhs, t, G, parameters, vdeOptions);
    vdeInitval = reshape(eye(yDim), [], 1);
    tSpan = [sol.x(1), sol.x(end)];

    solVde = integrator(vdeRhs, tSpan, vdeInitval, integratorOptions);

    fignum = 1234;
    fig = figure(fignum);
    % shift a little so it doesn't exactly cover the solution plot's window
    fig.Position = fig.Position + [32, -32, 0, 0];
    tGrid = linspace(tSpan(1), tSpan(end), 1000);
    for r=1:yDim
        for c=1:yDim
            % the VDE solution was reshaped to column-major order, while subplot goes row-major.
            subplot(yDim, yDim, (r-1)*yDim + c);
            plot(tGrid, deval(solVde, tGrid, r + (c-1)*yDim));
            title(sprintf('G_{y,%d,%d}', r, c));
        end
    end
end