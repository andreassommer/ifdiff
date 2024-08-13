figure();
ax1 = subplot(1, 2, 1, 'replace');
ax2 = subplot(1, 2, 2, 'replace');

T = 0:0.01:2;
X = (T-1).^2;
Y = (T-1).^2-0.05;

subplot(ax1);
plot(T, X, 'LineWidth', 2);
ylim([-1 1]);
set(ax1, 'xticklabel', [], 'yticklabel', []);
yline(0, '--');
xline(0.5, '--', 't_1');
xline(1.5, '--', 't_3');

subplot(ax2);
plot(T, Y, 'LineWidth', 2);
ylim([-1 1]);
set(ax2, 'xticklabel', [], 'yticklabel', []);
yline(0, '--');
xline(0.5, '--', 't_1');
xline(1.5, '--', 't_3');
