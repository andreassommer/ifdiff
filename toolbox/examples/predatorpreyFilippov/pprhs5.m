function dx = pprhs5(t,state,p)
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
%

% preallocate output
dx = [0 , 0 , 0];

% x = (p1, p2, P)   % prey, prey2, predator
x = state(1);
y = state(2); 
z = state(3);

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
h = x - y;

% switched rhs
if h > 0
   % X(x,y,z) = [ (r1-z)*x , r2*y , (e*q1*x-m)*z ];
   dx(1) = (r1-z)*x     ;
   dx(2) = r2*y         ;
   dx(3) = (e*q1*x-m)*z ;
else
   % Y(x,y,z) = [ r1*x , (r2-beta2/beta1*z)*y , (e*q2/aq*y-m)*z ];
   dx(1) = r1*x                 ;
   dx(2) = (r2-beta2/beta1*z)*y ;
   dx(3) = (e*q2/aq*y-m)*z      ;
end

end