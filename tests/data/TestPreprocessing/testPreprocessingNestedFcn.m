function dy = testPreprocessingNestedFcn(~, y, p)
    % Nested function definition as first statement of the body.
    % It does not contain any switches, but reads a variable of the enclosing function.
    function out = threshold()
        out = c;
    end

    % Required in the switching function, although it is only used within the nested function.
    c = p(1);

    % Analytic solution for y0 = 0: y(t) = t for t <= c, y(t) = c + 2*(t - c) for t > c
    dy = 1;
    if y > threshold()
        dy = 2;
    end
end
