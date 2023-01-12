function dx = stickslip_rhs_single(t,x,p)
% Stick-slip model with known switching point - single file rhs
% 
% Source: Hans Georg Bock, Christian Kirches, Andreas Meyer, Andreas Potschka:
% Numerical solution of optimal control problems with explicit and implicit switches

% some physical constants
k  = 1.0;    % N/m  spring constant
m  = 1.0;    % kg   mass
Fs = 0.45;   % N    maximum static friction force
vb = 1.0;    % m/s  relative belt velocity
e  = 1.0d-15;% relaxation parameter for model switch

% relative speed
vrel = x(2) - vb;

% rhs
dx = zeros(2,1);
dx(1) = x(2);

if abs(vrel) < e
   F = min(abs(k*x), Fs) * sign(k*x);
else
   F = -Fs * sign(vrel) / (1 + delta*abs(vrel));
end

dx(2) = -k/m * x(1) + F / m;

end