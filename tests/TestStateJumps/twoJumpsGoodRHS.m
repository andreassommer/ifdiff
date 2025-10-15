function dx = twoJumpsGoodRHS(t, x, p)
%TWOJUMPSGOODRHS A RHS that has two jumps with the same switching function, but it's good because they
% have opposite direction flags and never interfere.
    dx = -sign(x);
    if ifdiff_jumpif(x, -1)
        ifdiff_update(-1);
    end
    if ifdiff_jumpif(x, 1)
        ifdiff_update(1);
    end
end

