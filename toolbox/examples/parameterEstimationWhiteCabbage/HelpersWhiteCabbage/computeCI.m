function CI = computeCI(p, res, J, alpha)
% CI = computeCI(p, res, J, varargin)
% computes the confidence confidence intervals in the parameter
% estimation problem in runCabbage.m
%   INPUT: 
%          p         - parameter vector (of optimized parameters)
% 	       res       - residual (from lsqnonlin solve)
%          J         - Jacobian
%          varargin: alpha - parameter in (0,1)
%   OUTPUT: 
%          CI        - two-sided confidence intervals

if nargin < 4
    alpha = 0.05; % defaultfor 95% CI
end

np = numel(p);
nr = numel(res);
dof = nr - np;
res_variance = sum(res.^2)/dof;

% approximation when a column is zero vector
index = find(max(abs(J)) == 0);
if ~isempty(index)
    J(:,index) = 1e-8;
end

% computation of parameter covariance matrix by QR factorization
[~, R] = qr(J, 0);
R_inv = R \ eye(size(R));
Cov_p = res_variance * R_inv * transpose(R_inv);

% critical t-value at 1-alpha/2
t_crit = tInv(alpha, dof);

% standard error
std_errors = sqrt(diag(Cov_p));
margin = t_crit * std_errors;

CI = [p - margin, p + margin];

end
