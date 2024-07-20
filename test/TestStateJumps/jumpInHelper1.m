function dx = jumpInHelper1(~, x, ~)
    sigma = x(1) - 5;
    dx = 1;
    ifdiff_jumpif(sigma, 1, x(1));
end

