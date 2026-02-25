function extendODEuntilSwitch(datahandle)
%EXTENDODEUNTILSWITCH   Extend ODE solution until switch and set new signature.
%   EXTENDODEUNTILSWITCH(datahandle)
%
%   Extend the ODE solution from the previous time point (t1) until the switching time (t2) using forced branching.
%   Note that t2 has to be part of the new model (i.e. have a new signature). To achieve this, the numerically
%   computed switching time (t2), which could still be part of the old model due to inaccuracies,
%   may be increased by this function.
%
%   INPUT
%   Accepts input via datahandle providing the fields
%       - SWP_detection.switch_cond_t1/t2 : switch condition before and after the numerically computed switch
%       - SWP_detection.t2 : numerically computed switching time
%       - SWP_detection.solution_until_t1 : ODE solution before the switch
%
%   OUTPUT
%   Writes results back to datahandle in the fields
%       - SWP_detection.t2 : updated switching time (guaranteed to be part of a new model)
%       - SWP_detection.solution_until_t2 : ODE solution until the updated switching time
%       - SWP_detection.switchingpoints : new switching time appended
%       - SWP_detection.signature : new signature appended


config = makeConfig();
data = datahandle.getData();

% Check if the numerically computed switching point is part of the new model.
extendODEuntilSwitch_t1_to_t2(datahandle);
extendODEuntilSwitch_updateSignature_t2(datahandle);
switchingIndices = getSwitchingIndices(datahandle, 0);

% The numerically computed switching point may still be part of the old model due to inaccuracies.
% In that case, slightly increment the switching point and reintegrate with forced branching.
% Repeat this process until a new signature is detected.
t2FromRootFinding = data.SWP_detection.t2;
baseOffset = 16*eps(data.SWP_detection.t2);
iter = 0;

while isempty(switchingIndices)
    data = datahandle.getData();

    % Throw error if error of switching point obtained from root finding relative to tspan exceeds threshold.
    % Note: No risk of division by zero since we need to make at least one integration step to detect a switch.
    switchingPointError = abs((data.SWP_detection.t2 - t2FromRootFinding) ...
        / (data.SWP_detection.tspan(end) - data.SWP_detection.tspan(1)));
    if switchingPointError > config.switchingPointErrorThreshold
        errorMsg = 'Relative error of numerically computed switching point exceeds threshold: %.16g > %.16g\n';
        error('IFDIFF:switchingPointErrorThreshold', errorMsg, switchingPointError, config.switchingPointErrorThreshold);
    end

    % Increase t2 and integrate again starting from t1.
    % We can not start integrating from the old t2 because this would result in integration over a tiny
    % interval whose result would vanish due to limited floating point accuracy.
    data.SWP_detection.t2 = data.SWP_detection.t2 + baseOffset * 10^min(iter, config.switchingPointMaxPower);
    
    datahandle.setData(data);

    % Check if there is a new signature.
    extendODEuntilSwitch_t1_to_t2(datahandle);
    extendODEuntilSwitch_updateSignature_t2(datahandle);
    switchingIndices = getSwitchingIndices(datahandle, 0);

    iter = iter + 1;
end

data = datahandle.getData();

% Log events related to searching for the switch.
if config.debugMode
    switchingPointInfo = "DEBUG: Detected switch after %d iterations at time point t=%.16g\n";
    fprintf(switchingPointInfo, iter, data.SWP_detection.t2);
end

% Add new switching point to history.
data.SWP_detection.switchingpoints{end + 1} = data.SWP_detection.t2;

datahandle.setData(data)
end