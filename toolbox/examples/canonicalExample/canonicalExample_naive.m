
% choose and configurate integrator
integrator   = @ode45;
options      = odeset();  % default options
options      = odeset(options, 'AbsTol', 1e-14, 'RelTol', 1e-12 );  % high "accuracy"
optionsExact = odeset(options, 'MaxStep', 0.001); % limit stepsize

% setup problem
tspan = [0, 15];
y0    = [1 0];
p     = 5.437;

% integrate
fprintf('Integrating ...')
tic
sol = integrator(@(t,x) canonicalExampleRHS(t,x,p), tspan, y0, options);
toc
fprintf('Integrating with limited step size...')
tic
soltrue = integrator(@(t,x) canonicalExampleRHS(t,x,p), tspan, y0, optionsExact);
toc

% evaluate solution
t = tspan(1):0.1:tspan(end);
y = deval(sol, t);
ytrue = deval(soltrue, t);

% plot
figure(123); clf; hold on
plot(t, y    , 'r-' , 'LineWidth', 2, 'DisplayName', 'ode45 (high accuracy)');
plot(t, ytrue, 'k--', 'LineWidth', 1, 'DisplayName', 'ode45 (limited stepsize, "true" solution)');
legend('Location', 'NorthWest')
