function extendODEuntilSwitch(datahandle) 
% Extend ODE until t2 (~the switch) using forced branching, i.e. the
% signature in the rhs is kept unchanged during extension. 
% INPUT: struct with fields SWP_detection.t2 (the exact switching point)
% and SWP_detection.solution_until_t1 set
% OUTPUT: field SWP_detection.solution_until_t2 updated.
% Since the t2 is computed using an approximate trajectory, it may be
% before the real switching point. To address this, we check after each odextend
% whether the switching function has changed and, if not, shift t2 gradually to the
% right until it passes the real switching point.

% timepoint t1 ~ t_i
% timepoint t2 ~ t_s
% timepoint t3 ~ t_iplus1

% first extension to t2
extendODEuntilSwitch_t1_to_t2(datahandle);

% check if Signature from t1 to t2 changed, i.e. if there occured a switch.
extendODEuntilSwitch_updateSignature_t2(datahandle);
s = getSwitchingIndices(datahandle, 0);

i = 0;
while isempty(s)

    data = datahandle.getData();
    % increase t2
    data.SWP_detection.t2 = data.SWP_detection.t2 + 10^i*16*eps(data.SWP_detection.t2);
    i = i+1; 
    % integrate until the new t2
    datahandle.setData(data);
    extendODEuntilSwitch_t1_to_t2(datahandle);  

    extendODEuntilSwitch_updateSignature_t2(datahandle);
    s = getSwitchingIndices(datahandle, 0);

    % We stop the increasing if the increase of t2 is too much to not be
    % justified by inaccuracies. 
    % We chose here: stop is t2 is increased by more then 1%. 
    % Hence display warning if i > 13
    if i > 13 
        warning('i>13');
    end
end

% when increasing the point t2 does not lead to a change of signature, display warning
if i > 1
    warning(['detected switch at ', num2str(data.SWP_detection.t2, '%32.16f\n'),' specified up ']);
end

data = datahandle.getData();
data.SWP_detection.switchingpoints{end + 1} = data.SWP_detection.t2;

datahandle.setData(data);
end