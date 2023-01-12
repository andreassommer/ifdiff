function dx = stickslip_rhs(t,x,p)
% Stick-slip model with known switching point
% 
% Source: Hans Georg Bock, Christian Kirches, Andreas Meyer, Andreas Potschka:
% Numerical solution of optimal control problems with explicit and implicit switches

% some physical constants
k  = 1.0;      % N/m  spring constant
m  = 1.0;      % kg   mass
%Fs = 1;     % N    maximum static friction force
Fs = 0.45;     % N    maximum static friction force
Fs=0.35;
vb = 1;        % m/s  relative belt velocity
%vb = 0.2;        % m/s  relative belt velocity
e  = 1.0d-15;  % relaxation parameter for model switch
e=0.1;
% relative speed
vrel = x(2) - vb;

% rhs
dx = zeros(2,1);
dx(1) = x(2);
dx(2) = -k/m * x(1) + stickslip_F(x(1), vrel, Fs, k, e) / m;

end