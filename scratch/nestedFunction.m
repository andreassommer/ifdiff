function y = nestedFunction(x)
    z = x + 1;
    a = z * 2 * x;
    function c = g(b)
        c = b + 2;
    end
    y = g(a);
end

