function dx = canonicalNested1(t, x, p)
% Test 1 of the canonical example with parts as nested functions
% here nested function within the function
dx = zeros(2,1);
nested1(p);

    function nested1(p)
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
end

