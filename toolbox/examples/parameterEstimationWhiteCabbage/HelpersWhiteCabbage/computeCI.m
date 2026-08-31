function CI = computeCI(param, res, J)
%COMPUTECI computes the confidence level 95% confidence intervals in White Cabbage PE
%   param - parameter vector (of optimized parameters)
% 	res   - residual function
%   J     - Jacobian

np = numel(param);
nr = numel(res);
dof = nr - np;

% variance
s2 = (transpose(res) * res) / dof;

% QR factorization for J and computation of
% parameter covariance matrix
[~,R] = qr(J,0);
Rinv = R \ eye(size(R));
CovP = s2 * (Rinv * transpose(Rinv));

% critical t-value
% we use 1-alpha=0.95 => alpha=0.05
% and hence tcrit=1-alpha/2 = 0.975
tcrit = tInv(0.975, dof);

% standard error
SE = sqrt(diag(CovP));

CI = [param - tcrit*SE, param + tcrit*SE];

end
