T1 = 0:0.01:1;
T2 = 1:0.01:2;
X1 = 0.1*T1.^2;
X22 = 0.1*T2.^2;
X2 = 0.1*T2;
plot(T2, X22, 'LineWidth', 2)
hold on;
plot([T1 T2], [X1 X2], 'LineWidth', 2)
set(gca, 'xticklabel', [], 'yticklabel', []);
legend('continuation of model 1', 'correct (switched) solution')
xlabel('t');
ylabel('x(t)');