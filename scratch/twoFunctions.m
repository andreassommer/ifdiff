function y = twoFunctions(x)
    z = secondFunction(x);
    function b = secondFunction(a)
        b = 2 * a;
    end
    y = thirdFunction(z);
    function f = fourthFunction(e)
        f = exp(e);
    end
end

function d = thirdFunction(c)
    d = c + 1;
end