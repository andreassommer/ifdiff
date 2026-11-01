function dx = testPreprocNestedWrite(t,x,p)
%TESTPREPROCNESTEDWRITE Variant of the issue example (same solution).
%   A nested function without outputs writes a local variable of the enclosing function used in the conditions.
    function out = q1(t)
        out = 50/27*t.^2 - 100/3*t + 400/3;
    end
    function out = q2(t, x, p)
        out = (1000 - x(2))*(p(1)*(t-19) + p(2));
    end
    function setLimits()
        limits = [750, 800];
    end

    % Shared variables have to be initialized in the enclosing function.
    limits = [0, 0];
    setLimits();
    
    dx = zeros(2,1);
    
    if x(1) <= limits(1)
        dx(1) = q1(t);
    else
        dx(1) = q1(t) - q2(t,x,p);
    end
    
    if x(1) <= limits(1)
        dx(2) = 0;
    else
        if x(1) <= limits(2)
            dx(2) = -300;
        else
            dx(2) = 0;
        end
    end
end
