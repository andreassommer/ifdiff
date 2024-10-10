function dx = twoJumpsGoodRHS(t, x, p)
%TWOJUMPSGOODRHS A RHS that has two jumps with the same switching function, but it's good because they
% have opposite direction flags and never interfere.
    dx = -sign(x);
    ifdiff_jumpif(x, -1, -1);
    ifdiff_jumpif(x, 1, 1);
end

