function dx = friction_model_RHSmod2(t, x, p)
% p = (k, m, mu_b, F_s, delta, epsilon)
k       = p(1);
m       = p(2);
mu_b    = p(3);
F_s     = p(4);
delta   = p(5);
epsilon = p(6);
mu_rel  = x(2) - mu_b;

dx = zeros(2,1);
dx(1) = x(2);

dx(2) = -(k / m) * x(1) + F_fric_mod2(x, mu_rel, epsilon, F_s, k, delta) / m;

end
