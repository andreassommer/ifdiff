function dx = rlcRHS(~,x,p)
    dx  = zeros(3,1);
    L   = p(1); R1  = p(2); R2  = p(3);
    C   = p(4); Vs  = p(5); Vth = p(6);
    IL  = x(1); VC  = x(2); IC  = x(3);

    if VC > Vth
        dx(1) = (Vs - R1*IL - VC)/L;
    else
        dx(1) = (Vs - R2*IL - VC)/L;
    end 
    dx(2) = IC/C;
    dx(3) = IL - IC; % algebraic constraint
end