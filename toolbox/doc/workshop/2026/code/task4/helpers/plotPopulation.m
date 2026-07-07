function plotPopulation(solution, ax)
if nargin < 2
    fig = figure;
    ax = axes(fig);
end

nPoints = 1000;
t = jumpLinspace(solution.x(1), solution.x(end), solution.switches, nPoints);
P = deval(solution, t, 1);
plot(ax, t, P);

xlim(ax, 'tight');
ylim(ax, 'tight');

grid(ax, 'on');

title(ax, sprintf('Population over time with threshold harvesting (T=%g, \\alpha=%g)', solution.parameters));
xlabel(ax, 'Time');
ylabel(ax, 'Population');
end
