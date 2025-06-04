function CanonicalSensPlot(t_plot, sensitivities_END_plot, num)

    sensall1 = arrayfun(@(x) x.Gy(1,1), sensitivities_END_plot);
    figure(num);
    subplot(2,2,1)
    plot(t_plot,sensall1, '.b')
    xlabel('t');
    ylabel('\partial y_1(t)/\partial y_{0,1}')
    title('G_{y,11}(t; t_0)')
    set(gca, 'FontSize', 12);
    set(gca, 'Box', 'off');

    sensall2 = arrayfun(@(x) x.Gy(1,2), sensitivities_END_plot);
    subplot(2,2,2)
    plot(t_plot,sensall2, '.b')
    xlabel('t');
    ylabel('\partial y_1(t)/\partial y_{0,2}')
    title('G_{y,12}(t; t_0)')
    set(gca, 'FontSize', 12);
    set(gca, 'Box', 'off');
    
    sensall3 = arrayfun(@(x) x.Gy(2,1), sensitivities_END_plot);
    subplot(2,2,3)
    plot(t_plot,sensall3, '.b')
    xlabel('t');
    ylabel('\partial y_2(t)/\partial y_{0,1}')
    title('G_{y,21}(t; t_0)')
    set(gca, 'FontSize', 12);
    set(gca, 'Box', 'off');
    
    sensall4 = arrayfun(@(x) x.Gy(2,2), sensitivities_END_plot);
    subplot(2,2,4)
    plot(t_plot,sensall4, '.b')
    xlabel('t');
    ylabel('\partial y_2(t)/\partial y_{0,2}')
    title('G_{y,22}(t; t_0)')
    set(gca, 'FontSize', 12);
    set(gca, 'Box', 'off');
end

