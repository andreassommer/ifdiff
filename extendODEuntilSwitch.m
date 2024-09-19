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

% Check if the numerically computed switching point is part of the new model.
extendODEuntilSwitch_t1_to_t2(datahandle);
data = datahandle.getData();
switchingIndices = getSwitchingIndices(datahandle, 0);

% The numerically computed switching point may still be part of the old model due to inaccuracies.
% In that case, slightly increment the switching point and reintegrate with forced branching.
% Repeat this process until a new signature is detected.
originalT2 = data.SWP_detection.t2;
switchingPointRelErrorPrinted = false;
baseOffset = 16*eps(data.SWP_detection.t2);
iter = 0;
while isempty(switchingIndices)
    % Increase t2 and integrate again starting from t1.
    % We can not start integrating from the old t2 because this would result in integration over a tiny
    % interval whose result would vanish due to limited floating point accuracy.
    data.SWP_detection.t2 = data.SWP_detection.t2 + baseOffset * 10^min(iter, config.switchingPointMaxPower);
    datahandle.setData(data);
    extendODEuntilSwitch_t1_to_t2(datahandle);

    % Check if there is a new signature.
    data = datahandle.getData();
    switchingIndices = getSwitchingIndices(datahandle, 0);

    % Print warning (once) if relative error of numerically computed switching point exceeds threshold.
    if ~switchingPointRelErrorPrinted
        switchingPointRelError = abs((data.SWP_detection.t2 - originalT2) / originalT2);
        if switchingPointRelError > config.switchingPointRelTolWarningThreshold
            switchingPointRelErrorPrinted = true;
            relErrorWarning = 'Relative error of numerically computed switching point exceeds threshold: %.16g > %.16g\n';
            warning('IFDIFF:switchingPointRelError', relErrorWarning, switchingPointRelError, config.switchingPointRelTolWarningThreshold);
        end
    end

    iter = iter + 1;
end

% Log events related to searching for the switch.
if config.debugMode
    switchingPointInfo = "DEBUG: Detected switch after %d iterations at time point t=%.16g\n";
    fprintf(switchingPointInfo, iter, data.SWP_detection.t2);
end

% Add new switching point to history.
data = datahandle.getData();
data.SWP_detection.switchingpoints{end + 1} = data.SWP_detection.t2;

% Get the new signature at t2 and add it to the signature history.
[switch_cond, ctrlif_index, function_index] = ctrlif_getSignature(...
    datahandle, ...
    data.SWP_detection.t2, ...
    deval(data.SWP_detection.solution_until_t2, data.SWP_detection.t2));
data.SWP_detection.signature.switch_cond{end+1} = switch_cond;
data.SWP_detection.signature.ctrlif_index{end+1} = ctrlif_index;
data.SWP_detection.signature.function_index{end+1} = function_index;

datahandle.setData(data)
end
