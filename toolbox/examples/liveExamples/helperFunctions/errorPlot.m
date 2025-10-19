function errorPlot(fignum, x1, y1, y2, intname1, intname2)
   figure(fignum); clf;
   ydiff = calcDiff(y1, y2);
   semilogy(x1, ydiff, 'LineWidth', 1.0);
   xlabel('t'); ylabel('||y||_2');
   title(sprintf('difference %s and %s', intname1, intname2));
   grid on; box on;
end