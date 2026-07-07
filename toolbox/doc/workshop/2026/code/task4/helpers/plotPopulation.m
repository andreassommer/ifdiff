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


if isempty(solution.signature{1}.switchCond)
    titlestr = 'Population over time';
else
    titlestr = sprintf('Population over time with threshold harvesting (T=%g, \\alpha=%g)', solution.parameters);
end
title(ax, titlestr);
xlabel(ax, 'Time');
ylabel(ax, 'Population');
end
