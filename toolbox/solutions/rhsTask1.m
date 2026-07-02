function dx = task1RHS(t, x, p)
    dx = zeros(2, 1);
    q1 = 50/27*t.^2 - 100/3*t + 400/3;

    if x(1) <= 750
        dx(1) = q1;
    else
        q2 = (1000-x(2)) * (p(1)*(t-19) + p(2));
        dx(1) = q1 - q2;
        if x(1) <= 800
            dx(2) = -300;
        end
    end
end