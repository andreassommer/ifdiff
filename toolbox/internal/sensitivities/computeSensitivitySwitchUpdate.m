function update = computeSensitivitySwitchUpdate(sensitivity, dirP, t, y, p, dyLeft, dyRight, dSigma, dJump)
%COMPUTESENSITIVITYSWITCHUPDATE - Compute sensitivity update at switch
%
%    Syntax
%      update = computeSensitivitySwitchUpdate(sensitivity, dirP, t, y, p, dyLeft, dyRight, dSigma, dJump)
%
%    Description
%       Applies sensitivity updates derived in [1, Sec. 4.4.3] directly to the sensitivities,
%       taking advantage of directional derivatives to avoid full Jacobian evaluation.
%
%    Input Arguments
%      sensitivity - Sensitivity to be updated
%        n-by-(m+k) numeric matrix, where n is the state dimension and m/k is the number of initial value/parameter sensitivity directions
%      dirP - Sensitivity directions for parameters
%        l-by-k numeric matrix, where l is the parameter dimension and k is the number of parameter sensitivity directions
%      t - Time at the switch
%        numeric scalar
%      y - State at the switch before jump updates
%        n-element numeric vector
%      p - System parameters
%        l-element numeric vector
%      dyLeft - RHS function value before the switch
%        n-element numeric vector
%      dyRight - RHS function value after the switch
%        n-element numeric vector
%      dSigma - Partial derivatives of the switching function
%        IFDIFFDerivative object implementing functions dt, dy and dp
%      dJump - Partial derivatives of the jump function
%        IFDIFFDerivative object implementing functions dt, dy and dp.
%        Empty if there is no jump at the switch.
%
%    Output Arguments
%      update - Sensitivity with the switch update applied
%        n-by-(m+k) numeric matrix, where n is the state dimension and m/k is the number of initial value/parameter sensitivity directions
%
%    References
%      [1] C. Kirches, "A Numerical Method for Nonlinear Robust Optimal
%          Control with Implicit Discontinuities and an Application to
%          Powertrain Oscillations," Diploma Thesis, Heidelberg University,
%          2006.
%          http://mathopt.de/PUBLICATIONS/Kirches2006.pdf

update = sensitivity;
% Split into initial value and parameter sensitivities. Initial value sensitivities come first.
[dim, nDir] = size(sensitivity);
nDirP = size(dirP, 2);
nDirY = nDir - nDirP;

hasParameter = nDirP > 0;
hasJump = ~isempty(dJump);

% Compute derivative of solution w.r.t. switching time: dydts = f_p - f_m - jump_t - jump_y*f_m
dydts = dyRight - dyLeft;
if hasJump
    jumpDyPartial = dJump.dy(t, y, p, [dyLeft, sensitivity]);
    dydts = dydts - dJump.dt(t, y, p, 1) - jumpDyPartial(:, 1);

    % Apply state jump updates: s += jump_y*s
    update = update + jumpDyPartial(:, 2:end);
    % For parameters additionally do s += jump_p*dir_p
    if hasParameter
        update(:, nDirY+1:end) = update(:, nDirY+1:end) + dJump.dp(t, y, p, dirP);
    end
end

if all(dydts == 0)
    % Remaining outer product term would be zero, so we are done here.
    return
end

% Compute derivative of switching time w.r.t. initial values and parameters: dts = sigma_y*s + sigma_p*dir_p
dts = dSigma.dy(t, y, p, sensitivity);
if hasParameter
    dts(nDirY+1:end) = dts(nDirY+1:end) + dSigma.dp(t, y, p, dirP);
end

if all(dts == 0)
    % Remaining outer product term would be zero, so we are done here.
    return
end

% Compute total derivative of switching function w.r.t. time using chain rule: dSigmaDt = sigma_t + sigma_y*dydt
dSigmaDt = dSigma.dt(t, y, p, 1) + dSigma.dy(t, y, p, dyLeft);

% Check that derivative is not too close to zero.
dSigmaDtThreshold = 10*eps(t);
if abs(dSigmaDt) < dSigmaDtThreshold
    throw(switchingFunctionDerivativeZeroException(dSigmaDt, dSigmaDtThreshold));
end

% Scale smaller vector in outer product by sigma/dt for efficiency.
if dim <= nDir
    dydts = dydts./dSigmaDt;
else
    dts = dts./dSigmaDt;
end

update = update + dydts * dts;
end


%% Exceptions
function e = switchingFunctionDerivativeZeroException(dt, thresh)
id = 'IFDIFF:Sensitvity:SwitchingFunctionDerivativeZero';
msg = [ ...
    'Unable to compute sensitivity update ', ...
    'because total derivative of switching function w.r.t. time is close to zero: dt=%.10g<%.10g'];
e = MException(id, msg, dt, thresh);
end
