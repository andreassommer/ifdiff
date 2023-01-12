% Model source: Christiansen, Maurer, Zirn: 
% "Optimal Control of a Voice-Coil-Motor with Coulombic Friction"
%
% States:  x(1) = motor mass position    x1
%          x(2) = motor mass velocity    v1
%          x(3) = load mass position     x2
%          x(4) = load mass velocity     v2
%          x(5) = electric current       I

% This is an optimal control problem; but we use the precomputed
% optimal solution for testing.


% initial state
x0 = [    0 , 0 ,    0 , 0 , 0 ].';

% final state (for testing)
xf = [ 0.01 , 0 , 0.01 , 0 , 0 ];

% times from file as struct
Umax = 3;
Ufun = @U_umax3;
times = getTimes(Umax);

% do explicit euler integration
tic
Neuler = 100000;                        % number of time steps
X = zeros(5, Neuler);                   % solution array
X(:,1) = x0;                            % copy initial state
T = zeros(1, Neuler);                   % time array
T(1) = times.t0;                        % copy initial time point
dt = (times.tf - times.t0) / Neuler;    % time increment
for k = 1:Neuler
   T(k+1)   = times.t0 + k*dt;
   X(:,k+1) = X(:,k) + dt * coulomb_rhs(T(k), X(:,k), Ufun);
   %if k > 10; break; end
end
fprintf('Euler integration took %g seconds.\n', toc());
Teuler = T;
Xeuler = X;


% try with ode-solver
odesolver = @ode15s;
tic
sol = odesolver(@(t,x) coulomb_rhs(t,x,@U_umax3), [times.t0, times.tf], x0);
fprintf('%s integration took %g seconds.\n', func2str(odesolver), toc());
Tode = Teuler;
Xode = deval(sol, Tode);


% plot solutions
plotsol(333, 'Euler', Teuler, Xeuler);
plotsol(334, func2str(odesolver), Tode, Xode);
plotsol(335, 'Differences', Teuler, Xeuler-Xode);


function [] = plotsol(fignum, name, T, X)
   figure(fignum); clf;
   ax1 = subplot(3,1,1); plot(T, X([1 3],:)); legend('x_1','x_2','Location','NorthWest');
   ax2 = subplot(3,1,2); plot(T, X([2 4],:)); legend('v_1','v_2','Location','NorthWest');
   ax3 = subplot(3,1,3); plot(T, X(  5  ,:)); legend('I','Location','NorthWest');
   sgtitle(sprintf('SOLVER: %s', name));
   linkaxes([ax1 ax2 ax3], 'x');
end

