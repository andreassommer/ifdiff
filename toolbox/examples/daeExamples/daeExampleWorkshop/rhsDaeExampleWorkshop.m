function f = rhsDaeExampleWorkshop(~, x, p)

    f = zeros(2,1);

    % algebraic constraint
    z = x(1) + x(2) + 10*(x(1)^5 + x(2)^3);
    f(2) = z;

    % differential equation
    if x(2) < p
        f(1) = x(2);
    else
        f(1) = 0;
    end

end
