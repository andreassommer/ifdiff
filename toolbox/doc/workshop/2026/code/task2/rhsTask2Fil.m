function dx = rhsTask2Fil(t, x, p)
% p = (k, m, mu_b, F_s, delta, epsilon)
k       = p(1);
m       = p(2);
v_b    = p(3);
F_s     = p(4);
delta   = p(5);
epsilon = p(6);
v_rel  = x(2) - v_b;

dx = zeros(2,1);
dx(1) = x(2);

dx(2) = -(k / m) * x(1) + F_Fil(x, v_rel, epsilon, F_s, k, delta) / m;

end
