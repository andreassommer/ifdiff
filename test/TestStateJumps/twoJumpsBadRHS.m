function dx = twoJumpsBadRHS(~, x, ~)
% Example RHS where two jumps occur at the same SWP, which is wrong and should be
% flagged appropriately by IFDIFF.
% Start with a positive x value.
    dx = -1;
    ifdiff_jumpif(x(1), -1, [-10]);
    ifdiff_jumpif(-x(1), 0, [-5]);
end
