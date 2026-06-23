function f = daeExampleRHS_reworked(~,x,p)

f = zeros(2,1);

% differential equation
if x(2) < p
    f(1) = 1;
else
    f(1) = 0;
end

% algebraic equation
f(2) = x(1) - 0.5*x(2)^2;

end