function plotPopulationGrid(solution)
[nT, nAlpha] = size(solution);
p = {solution.parameters};
T = cellfun(@(p) p(1), p(1:nT));

fig = figure;
tiles = tiledlayout(fig, nT, nAlpha);
for idx=1:numel(solution)
    ax = nexttile(tiles);
    plotPopulation(solution(idx), ax);

    yticks(ax, T);
    yl = ylim(ax);
    ylim(ax, [yl(1), T(find(yl(2) < T, 1))]);

    title(ax, sprintf('T=%g, \\alpha=%g', p{idx}));

    xlab = ax.XLabel.String;
    ylab = ax.YLabel.String;
    xlabel(ax, []);
    ylabel(ax, []);
end

xlabel(tiles, xlab);
ylabel(tiles, ylab);
title(tiles, 'Population over time for various threshold harvesting parameters')
end
