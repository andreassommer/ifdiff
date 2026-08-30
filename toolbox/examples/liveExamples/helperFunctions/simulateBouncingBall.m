function simulateBouncingBall(t0, tEnd, x0, p, solver, options)
    datahandle = prepareDatahandleForIntegration('rhsBounceball', 'solver', solver, 'options', options);
    sol = solveODE(datahandle, [t0 tEnd], x0, p);

    sensFun = generateSensitivityFunction(datahandle, sol, 'method', 'VDE', 'CalcGy', true, 'CalcGp', true);

    
    T = t0:0.01:tEnd;
    H = deval(sol, T, 1); % Height
    V = deval(sol, T, 2); % Velocity
    E = p(1) * H + 0.5 * V.^2; % Energy per mass

    plot(T, H, 'LineWidth', 2, 'DisplayName', 'h(t)', 'Color', [0 0.5 0.7]);
    hold on;
    plotSolWithJumps([t0 tEnd], sol, 2, 'v(t)', [0.2 0.7 0], struct(), 'LineWidth', 2);
    plot(T, E, 'LineWidth', 2, 'DisplayName', 'e(t)/m', 'Color', [0.6 0.6 0]);
    hold off;
    plotSensitivitiesSwitched(sol, sensFun, [t0 tEnd], struct(), struct(), 'LineWidth', 2);
end
