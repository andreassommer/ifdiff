function plot_comparison_subplots(fignum, tf, t0, T, Y_ifdiff, Y_euler, Y_matlabsolver, sol_ifdiff, integrator)
    Ydiff_Euler  = Y_euler        - Y_ifdiff;
    Ydiff_Matlab = Y_matlabsolver - Y_ifdiff;
    fignum = fignum + 1; 
    figure(fignum); clf;
    ymax = 30; 
    axes_limits = [0 tf 0 ymax]; 
    lw = 1.5;
    ax2 = subplot(3,1,1); 
    plot(T, Y_ifdiff, 'LineWidth', lw); 
    legend('x_1','x_2','Location','West'); 
    title(sprintf('ifdiff/%s with Switching Point Detection', func2str(integrator))); 
    axis(axes_limits); 
    xline(sol_ifdiff.switches(1), '--', 'DisplayName', 'Switches'); 
    xline(sol_ifdiff.switches(2), '--', 'DisplayName', '');
    ax3 = subplot(3,1,2); 
    plot(T, Ydiff_Euler, 'LineWidth', lw); 
    legend('x_1','x_2','Location','West'); 
    title(sprintf('Difference between AccurateEuler and ifdiff/%s', func2str(integrator)));
    text(t0 + 0.2, max(Ydiff_Euler(:)) * 0.94, 'note the scale');
    ax4 = subplot(3,1,3); 
    plot(T, Ydiff_Matlab, 'LineWidth', lw); 
    legend('x_1','x_2','Location','West');
    title(sprintf('Difference between matlab/%1$s and ifdiff/%1$s', func2str(integrator)));
    sgtitle('Canonical Example:  Comparison');
    linkaxes([ax2, ax3, ax4], 'x');
end
