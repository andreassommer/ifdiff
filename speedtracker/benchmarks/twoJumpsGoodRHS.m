function dx = twoJumpsGoodRHS(t, x, p)
%TWOJUMPSGOODRHS A RHS that has two jumps with the same switching function, but it's good because they
% have opposite direction flags and never interfere.

    % This is equivalent to using the sign function, but i didn't want every single iteration to print that
    % warning, so i did this manually.
    if x > 0
        dx = -1;
    else
        dx = 1;
    end
    ifdiff_jumpif(x, -1, -1);
    ifdiff_jumpif(x, 1, 1);
end

