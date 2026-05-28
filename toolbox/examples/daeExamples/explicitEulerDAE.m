function sol = explicitEulerDAE(rhs, DifferentialVars, tspan, x0, p, h, newtonOpts)
% explicitEulerDAE - Explicit Euler solver for semi-explicit, index 1 DAEs
%
% Solves: M * x' = f(t,x) by explicit Euler method
% INPUT:
%   rhs                 - function handle: f(t, x, p)
%   tspan               - [t0 tf]
%   x0                  - initial state
%   p                   - parameters
%   h                   - step size
%   newtonOpts          - struct with field
%   DifferentialVars    - number of differential variables
% OPTIONS:
%   maxIter (default 10)
%   tol (default 1e-10)
% OUTPUT:
%   sol.x               - time vector
%   sol.y               - solution matrix

    % default options
    if nargin < 7
        newtonOpts.maxIter = 10;
        newtonOpts.tol     = 1e-10;
    end

    t = tspan(1):h:tspan(2);
    N = length(t);

    nx = length(x0);
    x  = zeros(nx, N);
    x(:,1) = x0;

    % calculate dimensions
    nd = DifferentialVars; % number of differential variables
    na = nx - nd;          % number of algebraic variables

    for n = 1:N-1
        f_val = rhs(t(n), x(:,n), p);
        x(1:nd, n+1) = x(1:nd, n) + h * f_val(1:nd);
        z_guess = x(nd+1:end, n);
        
        for k = 1:newtonOpts.maxIter
            x_trial = [x(1:nd, n+1); z_guess];
            F = rhs(t(n+1), x_trial, p);
            g = F(nd+1:end); 
            J = zeros(na, na);
            eps_fd = 1e-8;
            
            for i = 1:na
                dz = zeros(na,1);
                dz(i) = eps_fd;
                
                x_eps = [x(1:nd, n+1); z_guess + dz];
                F_eps = rhs(t(n+1), x_eps, p);
                J(:,i) = (F_eps(nd+1:end) - g) / eps_fd;
            end
            
            % Newton step (differential variables)
            update = -J \ g;
            z_new = z_guess + update;
            
            if norm(update) < newtonOpts.tol
                break;
            end
            
            z_guess = z_new;
        end
        
        x(nd+1:end, n+1) = z_guess;
    end

    sol.x = t;
    sol.y = x;
end