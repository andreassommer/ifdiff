function export_figure(filename)
width = 16;
height = 10;

fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0, 0, width, height];
fontsize(fig, 12, 'points');

root = fileparts(mfilename('fullpath'));
filepath = fullfile(root, filename);

exportgraphics(fig, filepath, 'ContentType', 'vector');
end
