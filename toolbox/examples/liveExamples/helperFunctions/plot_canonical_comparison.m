function plot_canonical_comparison(fignum, tf, T, Y_ifdiff, Y_euler, Y_matlabsolver, sol_matlab, sol_ifdiff, ymax)
    figure(fignum); 
    clf('reset'); 
    hold on;
    axis([0 tf 0 ymax])
    plot(T, Y_ifdiff      , 'b-',  'LineWidth', 3);
    plot(T, Y_euler       , 'c-',  'LineWidth', 1);
    plot(T, Y_matlabsolver, 'r--', 'LineWidth', 1);    
    plot(sol_matlab.x, zeros(size(sol_matlab.x)), 'k*', 'MarkerSize', 8); 
    xline(sol_ifdiff.switches(1), '-', 'LineWidth', 1.0);
    xline(sol_ifdiff.switches(2), '-', 'LineWidth', 1.0);
    set(gca, 'XTick', 0:2:tf); 
    set(gca, 'YTick', [1, 5:5:ymax]); 
    title('Canonical Example:  Comparison of Results');
    legend('ifdiff', '', ...
           'accurate Euler', '', ...
           'matlab  WRONG!', '', ...
           'matlab steps', ...
           'switches', '', ...
           'Location', 'NorthWest');
end
