function dx = jumpInHelper1(~, x, ~)
    dx = 1;
    ifdiff_jumpif(x(1) - 5, 1, [5]);
end

