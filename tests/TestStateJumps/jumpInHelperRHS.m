function dx = jumpInHelperRHS(t, x, p)
% Test RHS for jumps in helper functions. Probably a bad idea to do this, but it shouldn't crash either.
    if x(1) < 15
        dx = jumpInHelper1(t, x, p);
    else
        dx = jumpInHelper2(t, x, p);
    end
end