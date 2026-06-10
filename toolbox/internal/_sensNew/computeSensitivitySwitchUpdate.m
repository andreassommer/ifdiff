function update = computeSensitivitySwitchUpdate( ...
    sens, dirP, ...
    tMinus, tPlus, yMinus, yPlus, p, ...
    fMinusFunc, fPlusFunc, ...
    sigmaDtPartialFunc, sigmaDyPartialFunc, sigmaDpPartialFunc, ...
    jumpDtPartialFunc, jumpDyPartialFunc, jumpDpPartialFunc)

update = sens;
% Determine which columns contain parameter sensitivities and which initial value sensitivities.
% Assumption: Initial value sensitivities come first, then parameter sensitivities.
[dim, nDir] = size(sens);
nDirP = size(dirP, 2);
nDirY = nDir - nDirP;
hasParameter = nDirP > 0;

if ~isempty(fPlusFunc) || ~isempty(jumpDyPartialFunc)
    fMinus = fMinusFunc(tMinus, yMinus, p);
else
    fMinus = [];
end

% Compute derivative of solution wrt switching time: f_p - f_m - jump_t - jump_y*f_m
% Also apply state jump updates: s += jump_y*s; for parameters additionally do s += jump_p*dir_p
derivativeSolutionWrtSwitchingTime = zeros(dim, 1);
if ~isempty(fPlusFunc)
    fPlus = fPlusFunc(tPlus, yPlus, p);
    derivativeSolutionWrtSwitchingTime = derivativeSolutionWrtSwitchingTime + fPlus - fMinus;
end
if ~isempty(jumpDtPartialFunc)
    derivativeSolutionWrtSwitchingTime = derivativeSolutionWrtSwitchingTime - jumpDtPartialFunc(tMinus, yMinus, p, []);
end
if ~isempty(jumpDyPartialFunc)
    % Evaluate jump_y in direction of sens and fMinus in one call for efficiency.
    % Last column belongs to fMinus.
    jumpDyPartial = jumpDyPartialFunc(tMinus, yMinus, p, [sens, fMinus]);
    update = update + jumpDyPartial(:, 1:end-1);
    derivativeSolutionWrtSwitchingTime = derivativeSolutionWrtSwitchingTime - jumpDyPartial(:, end);
end
if hasParameter && ~isempty(jumpDpPartialFunc)
    % Apply only to parameter sensitivities.
    update(:, nDirY+1:end) = update(:, nDirY+1:end) + jumpDpPartialFunc(tMinus, yMinus, p, dirP);
end
if all(derivativeSolutionWrtSwitchingTime == 0)
    % Remaining outer product term would be zero, so we are done here.
    return
end

% Compute derivative of switching time wrt initial value and parameter: sigma_y*s + sigma_p*dir_p
derivativeSwitchingTimeWrtParams = zeros(1, nDir);
if ~isempty(sigmaDyPartialFunc)
    derivativeSwitchingTimeWrtParams = derivativeSwitchingTimeWrtParams + sigmaDyPartialFunc(tMinus, yMinus, p, sens);
end
if hasParameter && ~isempty(sigmaDpPartialFunc)
    % Apply only to parameter sensitivity components
    derivativeSwitchingTimeWrtParams(nDirY+1:end) = derivativeSwitchingTimeWrtParams(nDirY+1:end) ...
        + sigmaDpPartialFunc(tMinus, yMinus, p, dirP);
end
if all(derivativeSwitchingTimeWrtParams == 0)
    % Remaining outer product term would be zero, so we are done here.
    return
end

% In case we haven't evaluated fMinus in the previous section.
if isempty(fMinus)
    fMinus = fMinusFunc(tMinus, yMinus, p);
end

% Compute sigma/dt using chain rule.
sigmaDtPartial = sigmaDtPartialFunc(tMinus, yMinus, p, []);
sigmaDyPartialFminus = sigmaDyPartialFunc(tMinus, yMinus, p, fMinus);
sigmaDtTotal = sigmaDtPartial + sigmaDyPartialFminus;

% Check that sigma/dt is not too close to zero.
sigmaDtThreshold = 10*eps(tMinus);
if abs(sigmaDtTotal) < sigmaDtThreshold
    throw(switchingFunctionDerivativeZeroException(sigmaDtTotal, sigmaDtThreshold));
end

% Scale smaller vector in outer product by sigma/dt for efficiency
if dim <= nDir
    derivativeSolutionWrtSwitchingTime = derivativeSolutionWrtSwitchingTime./sigmaDtTotal;
else
    derivativeSwitchingTimeWrtParams = derivativeSwitchingTimeWrtParams./sigmaDtTotal;
end

update = update + derivativeSolutionWrtSwitchingTime * derivativeSwitchingTimeWrtParams;
end


%% Exceptions
function e = switchingFunctionDerivativeZeroException(dt, thresh)
id = 'IFDIFF:Sensitvity:UpdateSwitchingFunctionDerivativeZero';
msg = [ ...
    'Unable to compute sensitivity update, ', ...
    'because total derivative of switching function w.r.t. time is close to zero: dt=%.10g<%.10g'];
e = MException(id, msg, dt, thresh);
end
