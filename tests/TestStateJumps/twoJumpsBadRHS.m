function dx = twoJumpsBadRHS(~, x, ~)
% Example RHS where two jumps occur at the same SWP, which is wrong and should be
% flagged appropriately by IFDIFF.
% Start with a positive x value.
    dx = -1;
    if ifdiff_jumpif(x(1), -1)
        ifdiff_update(-10);
    end
    if ifdiff_jumpif(-x(1), 0)
        ifdiff_update(-5);
    end
end
