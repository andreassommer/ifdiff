function dx = rlcRHS(~,x,p)
    L = p(1); R1 = p(2); R2 = p(3); C = p(4); Vs = p(5); Vth = p(6);
    iL = x(1); vC = x(2); iC = x(3);
    
    dx = zeros(3,1);
    if vC > Vth  % Mode 1: High resistance (e.g., fuse intact)
        dx(1) = (Vs - R1*iL - vC)/L;
        dx(2) = iC/C;
        dx(3) = iL - iC;  % KCL unchanged
    else          % Mode 2: Low resistance (e.g., fuse blown, shorted)
        dx(1) = (Vs - R2*iL - vC)/L;
        dx(2) = iC/C;
        dx(3) = iL - iC;  % Same algebraic constraint
    end 
end