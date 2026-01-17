function dydt = circuitRHS(~, x, p_vec)

    dydt = zeros(3,1);

    iL     = x(1);  % Inductor current
    vC     = x(2);  % Capacitor voltage  
    i_fuse = x(3);  % Fuse current (algebraic)
    
    R1 = p_vec(1);
    R2 = p_vec(2);
    L = p_vec(3);
    C = p_vec(4);
    Vsrc = p_vec(5);
    I_threshold = p_vec(6);

    dydt(3) = iL - i_fuse - vC/R2;

    if abs(i_fuse) <= I_threshold
        dydt(1) = (Vsrc - R1*iL - vC)/L;           % Inductor
        dydt(2) = (iL - vC/R2)/C;                  % Capacitor  
        dydt(3) = iL - i_fuse - vC/R2;             % KCL constraint
                 
    else 
        dydt(1) = (Vsrc - R1*iL - vC)/L;           % Inductor  
        dydt(2) = (iL - vC/R2)/C;                  % Capacitor
        dydt(3) =  i_fuse;                         % Fuse blown: i_fuse=0
    end