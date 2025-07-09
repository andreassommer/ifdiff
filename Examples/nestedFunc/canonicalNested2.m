function dx = canonicalNested2(t, x, p)
% Test 2 of the canonical example with parts as nested functions
% here nested function outside the function
dx = nested2(t, x, p);
end

function dx = nested2(t, x, p)
dx = zeros(2,1);
dx(1) = 0.01 * t.^2  +  x(2).^3;

if x(1) < p(1)
    dx(2) = 0;
else
    if x(1) < p(1) + 0.5
        dx(2) = 5;
    else
        dx(2) = 0;
    end
end
end