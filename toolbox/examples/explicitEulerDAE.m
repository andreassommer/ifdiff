function sol = explicitEulerDAE(rhs, M, tspan, x0, p, h, m, newtonOpts)

    if nargin < 8 || isempty(newtonOpts)
        newtonOpts.maxIter = 10;
        newtonOpts.tol     = 1e-10;
    end
    
    t0 = tspan(1);
    tf = tspan(2);
    
    % Use loop-based time stepping to avoid giant time vector preallocation
    % Total expected steps (excluding t0)
    total_steps = round((tf - t0) / h);
    
    % Preallocate only the stored steps to save massive memory
    % We store step 0 (initial condition), plus every m-th step
    num_stored = 1 + floor(total_steps / m);
    
    nx = length(x0);
    sol_y = zeros(nx, num_stored);
    sol_x = zeros(1, num_stored);
    
    % Initialize first column
    sol_y(:,1) = x0;
    sol_x(1)   = t0;
    
    % Extract options to avoid structure lookups inside the hot loop
    maxIter = newtonOpts.maxIter;
    tol     = newtonOpts.tol;
    
    diff_idx = diag(M) ~= 0;
    alg_idx  = ~diff_idx;
    
    nd = sum(diff_idx);
    na = sum(alg_idx);
    
    % Current state vectors to avoid frequent indexing into large arrays
    x_curr = x0;
    x_next = zeros(nx, 1); 
    
    % Localize indices for speed
    diff_idx = 1:nd;
    alg_idx  = (nd+1):nx;
    
    stored_count = 1;
    t = t0;
    
    % Main integration loop
    for step = 1:total_steps
        % 1. Explicit Euler step for differential variables
        f_val = rhs(t, x_curr, p);
        x_next(diff_idx) = x_curr(diff_idx) + h * f_val(diff_idx);
        
        % Advance time
        t = t0 + step * h; 
        
        % 2. Newton-Raphson for algebraic variables
        z_guess = x_curr(alg_idx); 
        x_trial = x_next; % Base template for Newton iterations
        
        for k = 1:maxIter
            x_trial(alg_idx) = z_guess;
            F = rhs(t, x_trial, p);
            g = F(alg_idx); 
            
            % Check convergence early before building Jacobian
            if k > 1 && norm(update, Inf) < tol
                break;
            end
            
            % Finite difference Jacobian estimation
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
        
        % Finalize state for this step
        x_next(alg_idx) = z_guess;
        x_curr = x_next;
        
        % 3. Check if this step should be stored (every m-th step)
        if mod(step, m) == 0
            stored_count = stored_count + 1;
            sol_y(:, stored_count) = x_curr;
            sol_x(stored_count)   = t;
        end
    end
    
    % Handle truncation if total_steps wasn't perfectly divisible by m
    sol.x = sol_x(1:stored_count);
    sol.y = sol_y(:, 1:stored_count);
end