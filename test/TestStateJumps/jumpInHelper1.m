function dx = jumpInHelper1(~, x, ~)
    sigma = x(1) - 5;
    dx = 1;
    if ifdiff_jumpif(sigma, 1)
        ifdiff_update(x(1));
    end
end

