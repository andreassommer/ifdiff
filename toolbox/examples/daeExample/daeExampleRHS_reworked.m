function f = daeExampleRHS_reworked(~,x,p)

f = zeros(2,1);
A = 0.7;
omega = 2.0;

% differential equation
if x(2) < p
    f(1) = x(2);
else
    f(1) = p - cos(x(2));
end

% algebraic equation
f(2) = x(1) + x(2) - x(2)^2 - p - A*sin(omega*x(1));

end