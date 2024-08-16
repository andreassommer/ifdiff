function dx = jumpSensitivityRHS(t, x, p)
%JUMPSENSITIVITYRHS A simple jumping model for testing sensitivity computation across jumps.
    dx = 0;
    if t * x(1) < (1/p(1))
        % solution: exp(px)
        dx(1) = p(1) * x(1);
    else
        % solution: sqrt(x)
        dx(1) = 1 / (2*x(1));
    end
    ifdiff_jumpif(t * x(1) - (1/p(1)), 1, x(1));
end

