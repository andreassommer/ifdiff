function dx = sign_inconsistent_rhs(t,x,p)

dx = zeros(1,1);
dx(1) = 2 - 4*sign(x(1)-p(1));

% dx = zeros(2,1);

% dx(1) = 4 + 2*sign(x(2)-p(1));
% dx(2) = 2 - 4*sign(x(2)-p(1));

end