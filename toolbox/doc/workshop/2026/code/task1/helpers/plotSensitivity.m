function plotSensitivity(sensitivity)
dimY = size(sensitivity(1).Gy, 1);
t = arrayfun(@(s) s.t, sensitivity);
Gy = arrayfun(@(s) s.Gy, sensitivity, 'UniformOutput', false);
Gy = reshape([Gy{:}], dimY, dimY, []);

fig = figure;
tiles = tiledlayout(fig, dimY, dimY);
for idxRow=1:dimY
    for idxCol=1:dimY
        ax = nexttile(tiles);
        plot(ax, t, squeeze(Gy(idxRow, idxCol, :)));
        xlabel(ax, 'Time');
        ylabel(ax, 'Sensitivity');
        title(ax, sprintf('G_y(%d, %d)', idxRow, idxCol));
    end
end

if isfield(sensitivity, 'Uy')
    titlestr = 'Initial value sensitivity with IFDIFF';
else
    titlestr = 'Initial value sensitivity with ode45';
end
title(tiles, titlestr);
end
