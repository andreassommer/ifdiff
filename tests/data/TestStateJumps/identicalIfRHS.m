function dx = identicalIfRHS(t, x, p)
%IDENTICALIFRHS RHS that contains two conditionals with the same switching function. How does IFDIFF handle this?
% Use starting values [1; 0]. Until t=1, x(1) will be exp(x) and x(2) will be p(2)*t^2. From
% t=1 onward, we have x(1) = exp(1 + p(1)*(t-1)), x(2) = t + p(2).
% For the test, we use the parameter sensitivity Gp11(t) = (t - 1) * exp(1 + p(1)*(t-1)).
    dx = zeros(2, 1);
    if x(1) < exp(1)
        dx(1) = x(1);
    else
        dx(1) = p(1) * x(1);
    end
    if x(1) < exp(1)
        dx(2) = 2*t*p(2);
    else
        dx(2) = 1;
    end
end

