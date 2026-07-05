function F = rhsTask3_new(t, x, p)
    x1 = x(1); x2 = x(2); y = x(3);
    q1 = (50/27)*t^2 - (100/3)*t + 400/3;
    
    if x1 <= 750
        dx1 = q1;
        dx2 = 0;
    elseif x1 < 800
        dx1 = q1 - y^2;
        dx2 = -300;
    else
        dx1 = q1 - y^2;        
        dx2 = 0;
    end
    
    F_alg = y^3 + x2*y - p(1)*x1 + p(2);
    
    F = [dx1; dx2; F_alg];
end
