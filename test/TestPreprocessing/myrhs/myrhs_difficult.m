function dx = myrhs_difficult(t,x,p)
    y = min(2*x(1), -x(2));
    
    y = 2*sign(x(3)*abs(y));
    
    if helper(x(3)) > 5
        y = y*5;
    end
    
    dx = y;
end