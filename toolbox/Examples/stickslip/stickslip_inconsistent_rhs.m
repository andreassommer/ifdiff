function dx = stickslip_inconsistent_rhs(t,x,p)
% Stick-slip model with INCONSISTENT switching
% 
% Source: Hans Georg Bock, Christian Kirches, Andreas Meyer, Andreas Potschka:
% Numerical solution of optimal control problems with explicit and implicit switches

% some physical constants
k  = 1.0;    % N/m  spring constant
m  = 1.0;    % kg   mass
Fs = 1.0;   % N    maximum static friction force
vb = 0.2;    % m/s  relative belt velocity
e  = 1.0d-15;% -    epsilon: relaxation parameter for model switch
d  = 3.0;    % s/m  delta: physical constant

% relative speed
vrel = x(2) - vb;

% rhs
dx = zeros(2,1);
dx(1) = x(2);
dx(2) = -k/m * x(1) + stickslip_inconsistent_F(x(1), vrel, Fs, k, e, d) / m;

end