function extendODEuntilSwitch(datahandle) 
% Extend ODE until t2 (~the switch) using forced evaluation, i.e. the
% signature in the rhs is kept unchanged during extension. 
% INPUT: struct with field SWP_detection and .t2 and .solution_until_t1
% OUTPUT: field SWP_detection.solution_until_t2 updated 
% or warning when after the switch no change of signature occured. 

% timepoint t1 ~ t_i
% timepoint t2 ~ t_s
% timepoint t3 ~ t_iplus1


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
while isempty(s)
    
    % increase t2
    data.SWP_detection.t2 = data.SWP_detection.t2 + 10^i*16*eps(data.SWP_detection.t2); 
    i = i+1; 
    % integrate until the new t2
    datahandle.setData(data); 
    extendODEuntilSwitch_t1_to_t2(datahandle);  
    
    data = datahandle.getData();
    s = getSwitchingIndices(datahandle, 0);
    

    % We stop the increasing if the increase of t2 is too much to not be
    % jutified by inaccuracies. 
    % We chose here: stop is t2 is increased by more then 1%. 
    % Hence display warning if i > 13
    if i > 13 
        warning('i>13')
    end
end

% when increasing the point t2 does not lead to a change of signature, display warning
if i > 1
    warning(['detected switch at ', num2str(data.SWP_detection.t2, '%32.16f\n'),' specified up '])
end

if isempty(s)
    % warning und alte signatur setzen
    warning('Problem not well-defined, switch cannot be detected') 
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













