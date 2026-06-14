function dt = vdeRhs(t, sens, p, solNominalTrajectory, nDirY, df, dirP)
y = deval(solNominalTrajectory, t);
dimy = length(y);

sensMatrix = reshape(sens, dimy, []);
% Separate columns into initial value and parameter sensitivities.
nDir = size(sensMatrix, 2);
nDirP = nDir - nDirY;

% State propagation applies to both sensitivities w.r.t. initial values and parameters.
sensMatrix = df.dy(t, y, p, sensMatrix);

% Add source term for parameter sensitivities.
if nDirP > 0
    sensMatrix(:, nDirY+1:end) = sensMatrix(:, nDirY+1:end) + df.dp(t, y, p, dirP);
end

% Flatten output in column-major order.
dt = sensMatrix(:);
end
