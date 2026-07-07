function plotGradient(solutionGrid, objectiveGrid, gradientGrid)
fig = figure;
ax = axes(fig);

plotObjective(solutionGrid, objectiveGrid, ax);

p = reshape({solutionGrid.parameters}, size(solutionGrid));
T = cellfun(@(p) p(1), p);
alpha = cellfun(@(p) p(2), p);

gradientGrid = reshape(cell2mat(gradientGrid), size(solutionGrid, 1), numel(p{1}), size(solutionGrid, 2));
gradientGrid = permute(gradientGrid, [2, 1, 3]);

gradientNorm = vecnorm(gradientGrid, 2, 1);
gradientGrid = gradientGrid ./ (gradientNorm + eps);
arrowLength = 0.075 * max(T(end) - T(1), alpha(end) - alpha(1));

dT = squeeze(gradientGrid(1, :, :));
dAlpha = squeeze(gradientGrid(2, :, :));
Z = zeros(size(objectiveGrid));

hold(ax, 'on');
quiver3(ax, T, alpha, objectiveGrid, arrowLength * dT, arrowLength * dAlpha, Z, 0, ...
    'Color', 'black', 'LineWidth', 2, 'MaxHeadSize', 0.1);
hold(ax, 'off');

title(ax, 'Total harvest and gradient for various threshold harvesting parameters');
end
