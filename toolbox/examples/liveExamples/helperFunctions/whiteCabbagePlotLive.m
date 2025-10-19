function whiteCabbagePlotLive(sol, sol_opt, measurements, t)
    measurements_plot = reshape(measurements, 3, []);

    figure;
    hold on

    % Colors
    c_orig = [0.08,0.05,0.68; 0.01,0.30,0.01; 0.44,0.07,0.02];
    c_opt  = [0.71,0.69,0.88; 0.72,0.92,0.72; 0.87,0.69,0.66];

    % Plot each variable
    for k = 1:3
        plot(sol.x, sol.y(k,:), 'LineWidth', 3, 'Color', c_orig(k,:));
        plot(sol_opt.x, sol_opt.y(k,:), '--', 'LineWidth', 3, 'Color', c_opt(k,:));
        plot(t, measurements_plot(k,:), '+', 'MarkerSize', 5, 'Color', c_orig(k,:));
    end

    xlabel('time [t]')
    ylabel('solution [y]')
    set(gca, 'Box', 'off');

    legend({
        '$y_L(t;{p}^{true})$', '$y_L(t;{p}^{opt})$', 'meas. $L$', ...
        '$y_S(t;{p}^{true})$', '$y_S(t;{p}^{opt})$', 'meas. $S$', ...
        '$y_H(t;{p}^{true})$', '$y_H(t;{p}^{opt})$', 'meas. $H$' ...
        }, ...
        'Interpreter', 'LaTeX', 'Location', 'best');

    hold off

    %% New figure: difference plot
    figure;
    hold on

    % Interpolate sol_opt.y to match sol.x
    sol_opt_interp_y = interp1(sol_opt.x', sol_opt.y', sol.x', 'linear', 'extrap')';

    for k = 1:3
        diff_y = abs(sol.y(k,:) - sol_opt_interp_y(k,:));
        plot(sol.x, diff_y, 'LineWidth', 2, 'Color', c_orig(k,:));
    end

    xlabel('time [t]')
    ylabel('|$y(t;p^{true}) - y(t;p^{opt})$|', 'Interpreter', 'LaTeX')
    title('Absolute Difference between True and Optimized Solutions')
    legend({'$|y_L^{diff}|$', '$|y_S^{diff}|$', '$|y_H^{diff}|$'}, 'Interpreter', 'LaTeX', 'Location', 'best')
    set(gca, 'Box', 'off');

    hold off
end
