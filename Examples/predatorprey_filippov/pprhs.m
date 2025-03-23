function dx = pprhs(t,x,p)
% Predator Prey Model 
%
% Source: 
% Tiago Carvalho, Douglas Duarte Novaes, Luiz Fernando Goncalves:
% Sliding Shilnikov connection in Filippov-type predator-prey model
% Nonlinear Dyn (2020) 100:2973-2987
%

% preallocate output
dx = [0 ; 0 ; 0];

% x = (p1, p2, P)   % prey, prey2, predator
p1 = x(1);
p2 = x(2); 
P  = x(3);

% p = (r1, r2, beta1, beta2, q1, q2, m, e, aq)  % parameters
r1    = p(1);
r2    = p(2);
beta1 = p(3);
beta2 = p(4);
q1    = p(5);
q2    = p(6);
m     = p(7);
e     = p(8);
aq    = p(9);

% switching manifold
H = beta1*p1 - aq*beta2*p2;
%fprintf('t=%22.17f  x=%.14f %.14f %.14f   H=%22.10f\n', t, x(1), x(2), x(3), H);
% switched rhs
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