function dx = jumpInHelperRHS(t, x, p)
% Test RHS for jumps in helper functions. ISHYGDDT, but it should be supported.
    if x(1) < 15
        dx = jumpInHelper1(t, x, p);
    else
        dx = jumpInHelper2(t, x, p);
    end
end

