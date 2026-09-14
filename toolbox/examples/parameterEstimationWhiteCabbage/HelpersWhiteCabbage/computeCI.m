function CI = computeCI(param, res, J)
%COMPUTECI computes the confidence level 95% confidence intervals in White Cabbage PE
%   param - parameter vector (of optimized parameters)
% 	res   - residual function
%   J     - Jacobian

np = numel(param);
nr = numel(res);
dof = nr - np;

% Approximation when a column is zero vector
temp = find(max(abs(J)) == 0);
if ~isempty(temp)
    J(:,temp) = sqrt(eps(class(J)));
end

% QR factorization for J and computation of
% parameter covariance matrix
[~,R] = qr(J,0);
Rinv = R \ eye(size(R));
diag_info = sum(Rinv.*Rinv, 2);
rmse = norm(res)/sqrt(dof);

% critical t-value
% we use alpha = 0.05
% and hence tcrit = 1-alpha/2 = 0.975
tcrit = tInv(0.975, dof);

% standard error
SE = sqrt(diag_info)*rmse;

CI = [param - tcrit*SE, param + tcrit*SE];

end
