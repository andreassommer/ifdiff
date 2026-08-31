function dx = rhsSignInconsistent2d(t,x,p)

dx = zeros(2,1);
sign_value = sign(x(2)-p(1));
dx(1) = 4 + 2*sign_value;
dx(2) = 2 - 4*sign_value;


% dx(1) = 4 + 2*sign(x(2)-p(1));
% dx(2) = 2 - 4*sign(x(2)-p(1));

end