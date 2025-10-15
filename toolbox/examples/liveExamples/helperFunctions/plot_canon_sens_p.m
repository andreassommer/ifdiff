function plot_canon_sens_p(t_plot, sensitivities_END_plot, sensitivities_END_plot2)
    % just for very specific example (only used in one live script)
    % arguments are as follows:
    %t_plot = 0:0.01:20;
    %sensitivities_END_plot2 = sensitivities_function_ENDpiecewise(t_plot);
    %sensitivities_END_plot = sensitivities_function_VDE(t_plot);
    
    figure(3)
    sensall5 = arrayfun(@(x) x.Gp(1,1), sensitivities_END_plot);
    subplot(1,2,1)
    plot(t_plot,sensall5, '.b')
    xlabel('t');
    ylabel('\partial y_1(t)/\partial p')
    title('VDE: G_{p,11}(t; t_0)')
    set(gca, 'FontSize', 12);
    set(gca, 'Box', 'off');
    
    sensall6 = arrayfun(@(x) x.Gp(2,1), sensitivities_END_plot);
    subplot(1,2,2)
    plot(t_plot,sensall6, '.b')
    xlabel('t');
    ylabel('\partial y_2(t)/\partial p')
    title('VDE: G_{p,21}(t; t_0)')
    set(gca, 'FontSize', 12);
    set(gca, 'Box', 'off');
    
    figure(4)
    sensall5 = arrayfun(@(x) x.Gp(1,1), sensitivities_END_plot2);
    subplot(1,2,1)
    plot(t_plot,sensall5, '.b')
    xlabel('t');
    ylabel('\partial y_1(t)/\partial p')
    title('Piece-wise: G_{p,11}(t; t_0)')
    set(gca, 'FontSize', 12);
    set(gca, 'Box', 'off');
    
    sensall6 = arrayfun(@(x) x.Gp(2,1), sensitivities_END_plot2);
    subplot(1,2,2)
    plot(t_plot,sensall6, '.b')
    xlabel('t');
    ylabel('\partial y_2(t)/\partial p')
    title('Piece-wise: G_{p,21}(t; t_0)')
    set(gca, 'FontSize', 12);
    set(gca, 'Box', 'off');
end

