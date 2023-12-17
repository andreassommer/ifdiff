function dx = rhs_test(t,x,p)
    
    if x(1) > p(1) 
        dx(1) = 0;
    else
        dx(1) = t;
        if x(2) > p(1) % IFDIFF:ignore
            dx(1) = 0; 
        end

        if x(1) < p(2) 
            dx(1) = 10;
        end
    end
    dx(2) = t;

end