% Lotka-Volterra Forward Integration and Plotting
clc; clear; close all;

%alpha = 0.2;   % Prey growth rate
%beta = 0.01;    % Predation rate
%delta = 0.1;   % Predator death rate
%gamma = 0.001;   % Predator growth rate
tspan = [0 25];

par = getParams_LV();
alpha = par(1);
beta = par(2);
gamma = par(3);
delta = par(4);

% Initial populations
x0 = 20;
y0 = 10;
init = [x0 y0];

% Lotka-Volterra ODEs
lotka = @(t, z) [
    alpha * z(1) - beta * z(1) * z(2);
    gamma * z(1) * z(2) - delta * z(2)
];

% Solve ODE and return result at fixed time points
rhs = @(t, y) LotkaVolterraRHS(t, y, par);
[t, z] = ode45(rhs, linspace(tspan(1), tspan(2), 26), init);

% Extract results
x = z(:,1);
y = z(:,2);

% Plot: Time series
figure;
subplot(2,1,1);
plot(t, x, 'b-', 'LineWidth', 2); hold on;
plot(t, y, 'r-', 'LineWidth', 2);
xlabel('Time');
ylabel('Population');
legend('Prey (x)', 'Predator (y)');
title('Lotka-Volterra Time Series');
grid on;

% Plot: Phase space
subplot(2,1,2);
plot(x, y, 'k', 'LineWidth', 2);
xlabel('Prey (x)');
ylabel('Predator (y)');
title('Phase Plot (Prey vs Predator)');
grid on;


% x = 20.0000 22.1890 24.7953 27.8868 31.5442 35.8629 40.9548 46.9501 53.9994 62.2750 71.9713 83.3040 96.5062 111.8209 129.4820 149.6930 172.5707 198.0749 225.8965 255.2506 284.6687 311.6655 332.5585 342.4896 336.7313 312.5784

% y = 10.0000 9.2410 8.5600 7.9518 7.4117 6.9359 6.5211 6.1652 5.8667 5.6256 5.4430 5.3218 5.2675 5.2885 5.3977 5.6144 5.9670 6.4972 7.2657 8.3617 9.9117 12.0882 15.1033 19.1784 24.4067 30.6013

% t = 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25