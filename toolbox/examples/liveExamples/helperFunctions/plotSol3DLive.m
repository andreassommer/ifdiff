function ax = plotSol3DLive(ax, x, name, lw, color, ls)
if isempty(ax)
    f = figure;
    ax = axes(f);
end
hold(ax, 'on');
plot3(ax, x(3, :), x(2, :), x(1, :), 'DisplayName', name, 'LineWidth', lw, 'Color', color, 'LineStyle', ls);
hold(ax, 'off');

view(ax, [97 51]);
box(ax, 'on');
grid(ax, 'on');
xlabel(ax, 'Predator');
ylabel(ax, 'Prey 2');
zlabel(ax, 'Prey 1');
legend(ax, 'location', 'northeast');
end
