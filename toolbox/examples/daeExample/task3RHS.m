function f = task3RHS(~,x,p)

f = zeros(2,1);
a = 0.7;
omega = 2.0;

% differential equation
if x(2) < p(1)
    f(1) = sin(x(2));
else
    f(1) = p(1) - cos(x(2));
end

% algebraic equation
f(2) = x(1) + x(2) - x(2)^2 - p(1) - a*sin(omega*x(1));

end