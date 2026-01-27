function dx = predatorPrey3D_rhs(~, x, p)
% 2-Prey-1-Predatory Model
%
% Source:
% Tiago Carvalho, Douglas Duarte Novaes, Luiz Fernando Goncalves:
% Sliding Shilnikov connection in Filippov-type predator-prey model
% Nonlinear Dyn (2020) 100:2973-2987

% Preallocate
dx = zeros(3, 1);

% Unpack state components and parameters
p1 = x(1); % prey1
p2 = x(2); % prey2
P  = x(3); % Predator

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
H = beta1*p1 - aq*beta2*p2;

if H >= 0
    dx(1) = (r1 - beta1*P) .* p1;
    dx(2) = r2*p2;
    dx(3) = (e*q1*beta1*p1 - m) .* P;
else
    dx(1) = r1*p1;
    dx(2) = (r2 - beta2*P) .* p2;
    dx(3) = (e*q2*beta2*p2 - m) .* P;
end
end
