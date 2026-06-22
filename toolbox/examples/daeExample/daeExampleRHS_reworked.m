function f = daeExampleRHS_reworked(~, x, p)

    f = zeros(2,1);

    % algebraic constraint
    z = x(1) + x(2) + x(2)^3 - p; 
    f(2) = z;

    % differential equation
    if x(2) < p 
       f(1) = x(2);
    else
       f(1) = 0;
    end

end