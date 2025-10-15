function dx = helperInJumpRHS(t, x, p)
%HELPERINJUMPRHS RHS that has a jump with a helper function inside it. To verify that the helper does not
% get preprocessed despite having an if statement in it.
    dx = [1; 1];
    if ifdiff_jumpif(x(1) - 2, 1)
        delta = helperInJump1(x);
        ifdiff_update(delta);
    end
end

