function [T, Y_euler, Y_matlabsolver, Y_ifdiff] = run_accurate_euler(N_euler, t0, tf, initstates, p, canonicalExampleRHS, sol_matlab, sol_ifdiff)
    X = zeros(2, N_euler+1); 
    X(:,1) = initstates;     
    T = zeros(1, N_euler+1); 
    T(1) = t0;               
    dt = (tf - t0) / N_euler;  
    
    for k = 1:N_euler
        T(k+1)   = t0 + k * dt;
        X(:,k+1) = X(:,k) + dt * canonicalExampleRHS(T(k), X(:,k), p);
    end

    skipper = floor(N_euler / 1000);
    if skipper < 1, skipper = 1; end
    T = T(1:skipper:end);
    Y_euler = X(:,1:skipper:end);
    Y_matlabsolver = deval(sol_matlab, T);
    Y_ifdiff       = deval(sol_ifdiff, T);
end
