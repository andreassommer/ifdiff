function CI = computeCI(p, res, J, varargin)
% CI = computeCI(p, res, J, varargin)
% computes the confidence confidence intervals in the parameter
% estimation problem in runCabbage.m
%   INPUT: p        - parameter vector (of optimized parameters)
% 	       res      - residual (from lsqnonlin solve)
%          J        - Jacobian
%          varargin - optional specification of significance level; 
%                    'alpha' - parameter in (0,1)

default_alpha = 0.05; % for 95% CI
alpha = olGetOption(varargin, 'alpha', default_alpha);

np = numel(p);
nr = numel(res);
dof = nr - np;
res_variance = sum(res.^2)/dof;

% Approximation when a column is zero vector
index = find(max(abs(J)) == 0);
if ~isempty(index)
    J(:,index) = 1e-8;
end

% computation of parameter covariance matrix by QR factorization
[~, R] = qr(J, 0);
Cov_p = res_variance * inv(R) * transpose(inv(R));

% critical t-value at 1-alpha/2
t_crit = tInv(alpha, dof);

% standard error
std_errors = sqrt(diag(Cov_p));
margin = t_crit * std_errors;

CI = [p - margin, p + margin];

end
