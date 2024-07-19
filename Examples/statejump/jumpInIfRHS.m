function dx = jumpInIfRHS(t, x, ~)
    % Nesting a jump into an if, to test that trace-return-back-to-inputs cleans up everything even
    % in this case
    if t < 4
        ifdiff_jumpif(x, 1, -4);
    else
        ifdiff_jumpif(x, 1, 4);
    end
    dx = 1;
end

