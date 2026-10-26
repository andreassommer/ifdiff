function dx = testPreprocNestedIssue(t,x,p)
%TESTPREPROCNESTEDISSUE Example from the issue on nested functions.
%   Nested function definitions are the first statements of the body.
    function out = q1(t)
        out = 50/27*t.^2 - 100/3*t + 400/3;
    end
    function out = q2(t, x, p)
        out = (1000 - x(2))*(p(1)*(t-19) + p(2));
    end

    dx = zeros(2,1);
    
    if x(1) <= 750
        dx(1) = q1(t);
    else
        dx(1) = q1(t) - q2(t,x,p);
    end
    
    if x(1) <= 750
        dx(2) = 0;
    else
        if x(1) <= 800
            dx(2) = -300;
        else
            dx(2) = 0;
        end
    end
end
