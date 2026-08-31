function CI = computeCI(param, res, J)
%COMPUTECI computes the 95% confidence intervals in White Cabbage PE
%   param - parameter vector (of optimized parameters)
% 	res   - residual function
%   J     - Jacobian

% get degrees of freedom
np = numel(param);
nr = numel(res);
dof = nr - np;

s2 = (transpose(res) * res) / dof;

% QR factorization since J is badly conditioned
[~,R] = qr(J,0);
Rinv = R \ eye(size(R));
CovP = s2 * (Rinv * transpose(Rinv));

% we use 1-alpha=0.95 => alpha=0.05
% and hence tcrit=1-alpha/2 = 0.975
tcrit = computeTinv(0.975, dof);

SE = sqrt(diag(CovP));

CI = [param - tcrit*SE, param + tcrit*SE];

end
