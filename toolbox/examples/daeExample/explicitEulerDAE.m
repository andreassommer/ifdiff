function sol = explicitEulerDAE(rhs, tspan, x0, p, h, newtonOpts)
% explicitEulerDAE - Explicit Euler solver for index-1 DAEs
%
% Solves: M * x' = f(t,x)
% Assumptions:
%   - First component: differential variables
%   - Remaining: algebraic variables
%
% INPUT:
%   rhs         - function handle: f(t, x, p)
%   tspan       - [t0 tf]
%   x0          - initial state (must be consistent)
%   p           - parameters
%   h           - step size
%   newtonOpts  - struct with fields:
%                   maxIter (default = 5)
%                   tol     (default = 1e-10)
%
% OUTPUT:
%   sol.x       
%   sol.y       

    % Defaults
    if nargin < 6
        newtonOpts.maxIter = 5;
        newtonOpts.tol     = 1e-10;
    end

    t = tspan(1):h:tspan(2);
    N = length(t);

    nx = length(x0);
    x  = zeros(nx, N);
    x(:,1) = x0;

    
    nd = 1; % vllt noch anpassen?         
    na = nx - nd;

    for n = 1:N-1
        
        % Evaluate RHS
        f_val = rhs(t(n), x(:,n), p);
        
        % Explicit Euler for differential variables
        x(1:nd, n+1) = x(1:nd, n) + h * f_val(1:nd);
        
        % Newton method for algebraic variables
        z_guess = x(nd+1:end, n);
        
        for k = 1:newtonOpts.maxIter
            
            x_trial = [x(1:nd, n+1); z_guess];
            F = rhs(t(n+1), x_trial, p);
            g = F(nd+1:end);
            
            % Finite difference
            J = zeros(na, na);
            eps_fd = 1e-8;
            
            for i = 1:na
                dz = zeros(na,1);
                dz(i) = eps_fd;
                
                x_eps = [x(1:nd, n+1); z_guess + dz];
                F_eps = rhs(t(n+1), x_eps, p);
                
                J(:,i) = (F_eps(nd+1:end) - g) / eps_fd;
            end
            
            % Newton step
            delta = -J \ g;
            z_new = z_guess + delta;
            
            if norm(delta) < newtonOpts.tol
                break;
            end
            
            z_guess = z_new;
        end
        
        x(nd+1:end, n+1) = z_guess;
    end

    sol.x = t;
    sol.y = x;
end