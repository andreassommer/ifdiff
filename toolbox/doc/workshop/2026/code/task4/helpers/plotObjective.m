function plotObjective(solutionGrid, objectiveGrid, ax)
if nargin < 3
    fig = figure;
    ax = axes(fig);
end

p = reshape({solutionGrid.parameters}, size(solutionGrid));
T = cellfun(@(p) p(1), p);
alpha = cellfun(@(p) p(2), p);

surfc(ax, T, alpha, objectiveGrid, 'FaceAlpha', 0.5);
title(ax, 'Total harvest for various threshold harvesting parameters');
xlabel(ax, 'Harvest threshold');
ylabel(ax, 'Harvest ratio');
zlabel(ax, 'Total harvest');
end
