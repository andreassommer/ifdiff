function dx = testPreprocNestedHelper(t,x,p)
%TESTPREPROCNESTEDHELPER Helper function for testPreprocNestedHelperRHS containing nested functions.
%   Same as testPreprocNestedRead.
    function out = q1()
        out = 50/27*t.^2 - 100/3*t + 400/3;
    end
    function out = q2()
        out = (1000 - x(2))*(p(1)*(t-19) + p(2));
    end
    function out = lowerLimit()
        out = limits(1);
    end
    function out = upperLimit()
        out = limits(2);
    end

    % Only read within nested functions, but required in switching functions.
    limits = [750, 800];

    dx = zeros(2,1);
    
    if x(1) <= lowerLimit()
        dx(1) = q1();
    else
        dx(1) = q1() - q2();
    end
    
    if x(1) <= lowerLimit()
        dx(2) = 0;
    else
        if x(1) <= upperLimit()
            dx(2) = -300;
        else
            dx(2) = 0;
        end
    end
end
