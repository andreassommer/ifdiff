function exportPlotForSlide(filepath)
set(gca, 'FontSize', 16);
set(gca, 'LineWidth', 1.2);
set(gcf, 'Color', 'w');

fontsize_label = 18;
removeLabels();
%addLabelPredatorPrey(fontsize_label);
%addLabelSwitchingAlpha(fontsize_label);
addLabelSens(fontsize_label);

%removeLegend();
%addLegendPredatorPrey();
addLegendSens();

exportgraphics(gcf, filepath, 'Resolution', 300);
end

%% Labels
function removeLabels()
xlabel('');
ylabel('');
zlabel('');
end

function removeLabelsTwoAx()
xlabel('');
yyaxis('left');
ylabel('');
yyaxis('right');
ylabel('');
end

function addLabelPredatorPrey(fontsize_label)
xlabel('Räuber', 'FontSize', fontsize_label);
ylabel('Beute 2', 'FontSize', fontsize_label);
zlabel('Beute 1', 'FontSize', fontsize_label);
end

function addLabelSwitchingAlpha(fontsize_label)
xlabel('Zeit', 'FontSize', fontsize_label)
yyaxis('left')
ylabel('Konvexitätsparameter', 'FontSize', fontsize_label)
yyaxis('right')
ylabel('Schaltfunktion', 'FontSize', fontsize_label)
end

function addLabelSens(fontsize_label)
xlabel('Zeit', 'FontSize', fontsize_label);
ylabel('Sensitivität Räuber Anfangswert', 'FontSize', fontsize_label);
end

%% Legend
function removeLegend()
legend('hide');
end

function addLegendPredatorPrey()
legend('IFDIFF', 'expl. Euler');
end

function addLegendSens()
legend('IFDIFF', 'expl. Euler', 'Location', 'northwest');
end
