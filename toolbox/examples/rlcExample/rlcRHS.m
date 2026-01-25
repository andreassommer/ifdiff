function dx = rlcRHS(~,x,p)
    dx  = zeros(3,1);
    L   = p(1); R1  = p(2); R2  = p(3);
    C   = p(4); Vs  = p(5); Vth = p(6);
    iL  = x(1); VC  = x(2); iC  = x(3);

    if VC > Vth
        dx(1) = (Vs - R1*iL - VC)/L;
    else
        dx(1) = (Vs - R2*iL - VC)/L;
    end 
    dx(2) = iC/C;
    dx(3) = iL - iC; % algebraic constraint
end