function dx = coulomb_rhs(t,x,U)
% INPUT:   t - time
%          x - state
%          U - function handle of one variable (time) [voltage]
%
%
% Model source: Christiansen, Maurer, Zirn: 
% "Optimal Control of a Voice-Coil-Motor with Coulombic Friction"
%
% States:  x(1) = x1  motor mass position
%          x(2) = v1  motor mass velocity
%          x(3) = x2  load mass position
%          x(4) = v2  load mass velocity
%          x(5) = I   electric current

% some constants
[KF, k, KS, FR, m1, m2, L, R] = getParams();


dx = zeros(5,1);

% x1' = v1
dx(1) = x(2); 

% v1' = 1/m1 * (KF*I - k*(x1-x2) - FR*sign(v1))
dx(2) = 1/m1 * (KF*x(5) - k*(x(1)-x(3)) - FR*sign(x(2)));

% x2' = v2
dx(3) = x(4);   

% v2' = k/m2 * (x1 - x2)
dx(4) = k/m2 * (x(1) - x(3));

% I' = 1/L * (U - R*I - Ks*v1)
dx(5) = 1/L * (U(t) - R*x(5) - KS*x(2));

%disp(dx')
end