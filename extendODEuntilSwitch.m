function extendODEuntilSwitch(datahandle)
% Extend ODE until t2 (~the switch) using forced evaluation, i.e. the
% signature in the rhs is kept unchanged during extension.
% INPUT: struct with field SWP_detection and .t2 and .solution_until_t1
% OUTPUT: field SWP_detection.solution_until_t2 updated
% or warning when after the switch no change of signature occured.

% timepoint t1 ~ t_i
% timepoint t2 ~ t_s
% timepoint t3 ~ t_iplus1

config = makeConfig();


% first extension to t2
extendODEuntilSwitch_t1_to_t2(datahandle);


% check if Signature from t1 to t2 changed, i.e. if there occured a switch.
data = datahandle.getData();
s = getSwitchingIndices(datahandle, 0);


% some switches may not be determined by exactly one number or by a
% number that is just slightly bigger, but are within a range that e.g.
% depend on precision tolerances within the program.
% E.g. consider the following example:
% If one wants to test if u == 0, then this is implemented by
% abs(u) <= epsilon.
% Hence the switch will only be determined up to a precision that
% depends on epsilon.
i = 0;
stepSize = 16*eps(data.SWP_detection.t2);
while isempty(s)
    % increase t2
    data.SWP_detection.t2 = data.SWP_detection.t2 + stepSize;
    % integrate until the new t2
    datahandle.setData(data);
    extendODEuntilSwitch_t1_to_t2(datahandle);

    data = datahandle.getData();
    s = getSwitchingIndices(datahandle, 0);

    % Increase step size by factor 10 each iteration until we reach a reasonable limit.
    % Tradeoff between accuracy and speed.
    if i <= config.switchingPointMaxIter
        stepSize = stepSize * 10;
    end
    i = i + 1;
end

if config.debugMode && i > 0
    if i >= config.switchingPointMaxIter
        maxIterWarning = "DEBUG: Maximum number of iterations (%u) reached for step size during switching point detection.";
        warning(maxIterWarning, config.switchingPointMaxIter);
    end
    switchingPointInfo = "DEBUG: Detected switch after i=%d iterations at time point t=%.16f\n";
    fprintf(switchingPointInfo, i, data.SWP_detection.t2);
end

% save switchingpoint for output (.SWP_detection will be deleted afterwards)
data = datahandle.getData();
data.SWP_detection.switchingpoints{end + 1} = data.SWP_detection.t2;

% Get the new signature at t2, without forced branching
[switch_cond, ctrlif_index, function_index] = ctrlif_getSignature(...
    datahandle, ...
    data.SWP_detection.t2, ...
    deval(data.SWP_detection.solution_until_t2, data.SWP_detection.t2));
data.SWP_detection.signature.switch_cond{end+1} = switch_cond;
data.SWP_detection.signature.ctrlif_index{end+1} = ctrlif_index;
data.SWP_detection.signature.function_index{end+1} = function_index;

datahandle.setData(data)
end