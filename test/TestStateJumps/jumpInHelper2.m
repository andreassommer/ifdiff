function dx = jumpInHelper2(~, x, ~)
    if x(1) < 25
        dx = 2;
    else
        dx = 1;
    end
    jmp = x(1) - 20;
    ifdiff_jumpif(x(1) - 25, 1, jmp);
end

