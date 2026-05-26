function update = applySensitivitySwitchUpdate( ...
    sens, pInitialDir, nDirY, ...
    tMinus, tPlus, yMinus, yPlus, p, ...
    fMinusFunc, fPlusFunc, ...
    sigmaDtPartialFunc, sigmaDyPartialFunc, sigmaDpPartialFunc, ...
    jumpDtPartialFunc, jumpDyPartialFunc, jumpDpPartialFunc)

update = sens;
[dimy, nDir] = size(sens);
% Determine which columns contain parameter sensitivities and which initial value sensitivities.
nDirP = nDir - nDirY;
hasParameter = nDirP > 0;

if ~isempty(fPlusFunc) || ~isempty(jumpDyPartialFunc)
    fMinus = fMinusFunc(tMinus, yMinus, p);
else
    fMinus = [];
end

% Compute: f_p - f_m - jump_t - jump_y*f_m
% Also apply updates: s += jump_y*s; for parameters additionally do s += jump_p*dir_p
switchDiscontinuity = zeros(dimy, 1);
if ~isempty(fPlusFunc)
    fPlus = fPlusFunc(tPlus, yPlus, p);
    switchDiscontinuity = switchDiscontinuity + fPlus - fMinus;
end
if ~isempty(jumpDtPartialFunc)
    switchDiscontinuity = switchDiscontinuity - jumpDtPartialFunc(tMinus, yMinus, p, []);
end
if ~isempty(jumpDyPartialFunc)
    % Evaluate jump_y in direction of sens and fMinus in one call for efficiency.
    % Last column belongs to fMinus.
    jumpDyPartial = jumpDyPartialFunc(tMinus, yMinus, p, [sens, fMinus]);
    update = update + jumpDyPartial(:, 1:end-1);
    switchDiscontinuity = switchDiscontinuity - jumpDyPartial(:, end);
end
if hasParameter && ~isempty(jumpDpPartialFunc)
    % Apply only to parameter sensitivities.
    update(:, nDirY+1:end) = update(:, nDirY+1:end) + jumpDpPartialFunc(tMinus, yMinus, p, pInitialDir);
end
if all(switchDiscontinuity == 0)
    % Remaining outer product term would be zero, so we are done here.
    return
end

% Compute: sigma_y*s + sigma_p*dir_p
switchCoeffs = zeros(1, nDir);
if ~isempty(sigmaDyPartialFunc)
    switchCoeffs = switchCoeffs + sigmaDyPartialFunc(tMinus, yMinus, p, sens);
end
if hasParameter && ~isempty(sigmaDpPartialFunc)
    % Apply only to parameter sensitivity components
    switchCoeffs(nDirY+1:end) = switchCoeffs(nDirY+1:end) + sigmaDpPartialFunc(tMinus, yMinus, p, pInitialDir);
end
if all(switchCoeffs == 0)
    % Remaining outer product term would be zero, so we are done here.
    return
end

% In case we haven't evaluated fMinus in the previous section.
if isempty(fMinus)
    fMinus = fMinusFunc(tMinus, yMinus, p);
end

% Compute sigma/dt using chain rule.
sigmaDtPartial = sigmaDtPartialFunc(tMinus, yMinus, p, []);
sigmaDyPartialFMinus = sigmaDyPartialFunc(tMinus, yMinus, p, fMinus);
sigmaDtTotal = sigmaDtPartial + sigmaDyPartialFMinus;

% Check that sigma/dt is not too close to zero.
sigmaDtThreshold = 10*eps(tMinus);
if sigmaDtTotal < sigmaDtThreshold
    throw(switchingFunctionDerivativeZeroException(sigmaDtTotal, sigmaDtThreshold));
end

% Scale smaller vector in outer product by sigma/dt for efficiency
if dimy <= nDir
    switchDiscontinuity = switchDiscontinuity./sigmaDtTotal;
else
    switchCoeffs = switchCoeffs./sigmaDtTotal;
end

update = update + switchDiscontinuity * switchCoeffs;
end

%% Exceptions
function e = switchingFunctionDerivativeZeroException(dt, thresh)
id = 'IFDIFF:Sensitvity:UpdateSwitchingFunctionDerivativeZero';
msg = [ ...
    'Unable to compute sensitivity update, ', ...
    'because total derivative of switching function w.r.t. time is close to zero: dt=%.10g<%.10g'];
e = MException(id, msg, dt, thresh);
end

