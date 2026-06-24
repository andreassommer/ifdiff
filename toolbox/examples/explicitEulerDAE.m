function sol = explicitEulerDAE(rhs, M, tspan, x0, p, h, m, newtonOpts)

    if nargin < 8 || isempty(newtonOpts)
        newtonOpts.maxIter = 15;
        newtonOpts.tol     = 1e-12;
    end
    
    t0 = tspan(1);
    tf = tspan(2);
    
    total_steps = round((tf - t0) / h);
    
    num_stored = 1 + floor(total_steps / m);
    
    nx = length(x0);
    sol_y = zeros(nx, num_stored);
    sol_x = zeros(1, num_stored);
    
    sol_y(:,1) = x0;
    sol_x(1)   = t0;
    
    maxIter = newtonOpts.maxIter;
    tol     = newtonOpts.tol;
    
    diff_idx = diag(M) ~= 0;
    alg_idx  = ~diff_idx;
    
    nd = sum(diff_idx);
    na = sum(alg_idx);
    
    x_curr = x0;
    x_next = zeros(nx, 1); 
    
    diff_idx = 1:nd;
    alg_idx  = (nd+1):nx;
    
    stored_count = 1;
    t = t0;
    
    % Main integration loop
    for step = 1:total_steps
        f_val = rhs(t, x_curr, p);
        x_next(diff_idx) = x_curr(diff_idx) + h * f_val(diff_idx);
        
        t = t0 + step * h; 
        
        z_guess = x_curr(alg_idx); 
        x_trial = x_next;
        
        for k = 1:maxIter
            x_trial(alg_idx) = z_guess;
            F = rhs(t, x_trial, p);
            g = F(alg_idx); 
            
            if k > 1 && norm(update, Inf) < tol
                break;
            end
            
            J = zeros(na, na);
            eps_fd = 1e-6;
            for i = 1:na
                x_eps = x_trial;
                x_eps(nd + i) = x_eps(nd + i) + eps_fd;
                F_eps = rhs(t, x_eps, p);
                J(:,i) = (F_eps(alg_idx) - g) / eps_fd;
            end
            
            update = -J \ g;
            z_guess = z_guess + update;
        end
        
        x_next(alg_idx) = z_guess;
        x_curr = x_next;
        

        if mod(step, m) == 0
            stored_count = stored_count + 1;
            sol_y(:, stored_count) = x_curr;
            sol_x(stored_count)   = t;
        end
    end
    

    sol.x = sol_x(1:stored_count);
    sol.y = sol_y(:, 1:stored_count);
end