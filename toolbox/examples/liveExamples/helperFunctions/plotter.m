function h = plotter(fignum, y, color, name, lw)
   figure(fignum); hold on;
   h = plot3(y(3,:), y(2,:), y(1,:), 'Color', color, 'LineWidth', lw, 'DisplayName', name);
   view([97 51]); grid on; box on;
   xlabel('Predator'); ylabel('Prey 2'); zlabel('Prey 1');
   legend('location', 'northeast');
end