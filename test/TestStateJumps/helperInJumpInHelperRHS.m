function dx = helperInJumpInHelperRHS(~, x, ~)
%HELPERINJUMPINHELPERRHS An RHS with a jump inside a helper function, and that jump has a function call in it,
% and we want to verify that that function call does not get preprocessed.
    dx = helperInJumpInHelper1(x);
end

