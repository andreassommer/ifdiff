function dx = jumpInHelper2(~, x, ~)
    if x(1) < 25
        dx = 2;
    else
        dx = 1;
    end
    ifdiff_jumpif(x(1) - 25, 1, [5]);
end

