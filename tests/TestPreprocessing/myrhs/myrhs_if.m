function dx = myrhs_if(t,x,p)
    if x > 10
        dx = 5;
    else
        dx = 1;
    end
    
end

