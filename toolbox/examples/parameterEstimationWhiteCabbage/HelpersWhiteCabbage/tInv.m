function t_crit = tInv(alpha, dof)
% tcrit = tInv(alpha, dof)
% Computes the two-sided critical t-value for significance level alpha.
% INPUT: 
%        alpha  - significance level in (0,1) (e.g. alpha = 0.05 for 95% CI)
%        dof    - degrees of freedom
% OUTPUT: 
%        t_crit - critical t-value

% confidence level (e.g. 0.975 if alpha = 0.05)
conf_level = 1 - 0.5*alpha;

% Input validation
if dof <= 0
    error('Degrees of freedom must be positive');
end
if conf_level < 0 || conf_level > 1
    error('Cutoff must be in (0, 1)');
end

% at mid-point
tol = 1e-12;
if abs(conf_level - 0.5) < tol
    t_crit = 0;
    return;
end

% Computation for negative t
if conf_level < 0.5
    sign_t = -1;
    conf_level_pos = 1 - conf_level;
else
    sign_t = 1;
    conf_level_pos = conf_level;
end


%%
% CDF(t) = 1 - 0.5*betainc(dof/(dof+t^2), dof/2, 0.5)
% Solve: CDF(t) = conf_level_pos

objFunc = @(t) 1 - 0.5*betainc(dof./(dof + t.^2), dof/2, 0.5) - conf_level_pos;

t_upper = 1;
while objFunc(t_upper) < 0
    t_upper = t_upper * 2;
    if t_upper > 1e5
        error('Failed to bracket root for tInv; conf_level might be too close to 1');
    end
end

t_pos = fzero(objFunc, [0, t_upper]);
t_crit = sign_t * t_pos;

end