function dx = predatorPrey3D_formula5_rhs(~, state, p)
% Predator Prey Model
%
% Source:
% Tiago Carvalho, Douglas Duarte Novaes, Luiz Fernando Goncalves:
% Sliding Shilnikov connection in Filippov-type predator-prey model
% Nonlinear Dyn (2020) 100:2973-2987
%
% FORMULA 5
% X(x,y,z) = [ (r1-z)*x , r2*y , (e*q1*x-m)*z ];
% Y(x,y,z) = [ r1*x , (r2-beta2/beta1*z)*y , (e*q2/aq*y-m)*z ];

% Preallocate
dx = zeros(3, 1);

% Unpack state components and parameters (notation from paper)
x = state(1); % prey1
y = state(2); % prey2
z = state(3); % predator

r1    = p(1);
r2    = p(2);
beta1 = p(3);
beta2 = p(4);
q1    = p(5);
q2    = p(6);
m     = p(7);
e     = p(8);
aq    = p(9);

% Switching manifold
H = x - y;

if H > 0
    % X(x,y,z) = [ (r1-z)*x , r2*y , (e*q1*x-m)*z ];
    dx(1) = (r1-z) * x;
    dx(2) = r2 * y;
    dx(3) = (e*q1*x - m) * z;
else
    % Y(x,y,z) = [ r1*x , (r2-beta2/beta1*z)*y , (e*q2/aq*y-m)*z ];
    dx(1) = r1 * x;
    dx(2) = (r2 - beta2/beta1*z) * y;
    dx(3) = (e*q2/aq*y - m) * z;
end
end
