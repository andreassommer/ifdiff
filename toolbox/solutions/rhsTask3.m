function F = rhsTask3(t, x, p)
    % [x1; x2; y]
    x1 = x(1); x2 = x(2); y = x(3);
    
    p1 = p(1);
    p2 = p(2);
    q1 = (50/27)*t^2 - (100/3)*t + 400/3;
    k = 5;
    
    % Differential part
    if x1 <= 750
        dx1 = q1;
        dx2 = 0;
    elseif x1 < 800
        dx1 = q1 - k*y;
        dx2 = -300;
    else
        dx1 = q1 - k*y;
        dx2 = 0;
    end
    
    % Algebraic constraint
    alg_constraint = y^3 + x2*y - p1*x1 + p2;
    
    F = [dx1; dx2; alg_constraint];
end
