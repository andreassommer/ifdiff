function dx = helperInJumpInHelper1(x)
    dx = 1;
    if ifdiff_jumpif(x - 2, 1)
        delta = helperInJumpInHelper2(x);
        ifdiff_update(delta);
    end
end

