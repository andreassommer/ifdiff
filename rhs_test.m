function dx = rhs_test(t,x,p)
    
    if x(1) > p 
        dx(1) = 0;
    else
        dx(1) = t;
        if x(2) > p % IFDIFF:ignore
            dx(1) = 0; 
        end
    end
    dx(2) = t;

end