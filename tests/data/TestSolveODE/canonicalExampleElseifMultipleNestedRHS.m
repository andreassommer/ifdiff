function dx = canonicalExampleElseifMultipleNestedRHS(t,x,p)
dx = zeros(2,1);
dx(1) = 0.01 * t.^2  +  x(2).^3;

if x(1) < -1
    dx(1) = inf;
elseif x(1) < 0
    dx(1) = inf;
else
    dx(1) = dx(1) + 0;
end

if x(1) < p(1)
    if x(1) < -1
        dx(1) = inf;
        if x(1) < -1
            dx(1) = inf;
        elseif x(1) < 0
            dx(1) = inf;
        end
    elseif x(1) < 0
        dx(1) = inf;
    else
        dx(1) = dx(1) + 0;
    end
    dx(2) = 0;
elseif x(1) < p(1) + 0.5
    dx(2) = 5;
    if x(1) < -1
        dx(1) = inf;
    elseif x(1) < 0
        dx(1) = inf;
        if x(1) < -1
            dx(1) = inf;
        elseif x(1) < 0
            dx(1) = inf;
        end
    else
        dx(1) = dx(1) + 0;
    end
else
    if x(1) < -1
        dx(1) = inf;
    elseif x(1) < 0
        dx(1) = inf;
    else
        if x(1) < -1
            dx(1) = inf;
        elseif x(1) < 0
            dx(1) = inf;
        end
        dx(1) = dx(1) + 0;
    end
    dx(2) = 0;
end

if x(1) < -1
    dx(1) = inf;
elseif x(1) < 0
    dx(1) = inf;
end
end
