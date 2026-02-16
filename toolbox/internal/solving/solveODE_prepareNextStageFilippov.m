function solveODE_prepareNextStageFilippov(datahandle)
%SOLVEODE_PREPARENEXTSTAGEFILIPPOV(datahandle)
%
%Initialize datahandle fields for next round of integration after leaving Filippov sliding mode.
%
%INPUT:
%   SWP_detection.t2 - Time point where the Filippov sliding mode is no longer active.
%       double
%
%   SWP_detection.x2 - Corresponding solution value at the exit time point.
%       1xn double
%
%OUTPUT:
%   SWP_detection.switchingpoints - Filippov exit time appended as switching point.
%       (m+1)x1 cell array of double
%
%   SWP_detection.switchingFunction - Filippov switching function appended.
%       (m+1)x1 cell array of function_handle
%
%   SWP_detection.jumpFunction - Empty jump function appended (assume no jumps in Filippov).
%       (m+1)x1 cell array of (function_handle | empty)
%
%   SWP_detection.signature - Signature of new model at Filippov exit point appended.
%       (m+2)x1 cell array of BranchingSignature
%
%   sliding - Clear sliding mode fields, thus disabling Filippov sliding mode.
%       struct

data = datahandle.getData();
swp = data.SWP_detection;
t = swp.t2;
x = swp.x2;
% First entry pre-jump, second post-jump. Here same since assume no jump function.
swp.x2 = {x, x};

% Exact sliding mode exit time unimportant, since transition into new model is continuous.
% Therefore, just use the last integration step (where the exit was first detected).
swp.switchingpoints{end + 1} = t;
swp.switchingFunction(end + 1) = swp.switchingFunction(end);

% Assume no jumps in Filippov sliding mode.
swp.jumpFunction{end + 1} = [];

% Set signature of next model.
[switch_cond, ctrlif_index, function_index] = ctrlif_getSignature(datahandle, t, x);
signatureNew = BranchingSignature(data.mtreeplus{2, 1}, switch_cond, ctrlif_index, function_index);
swp.signature{end + 1} = signatureNew;
data.SWP_detection = swp;

% Clear Filippov data, thus disabling Filippov mode.
data.sliding = extendODE_filippov_regime_cleanup(data.sliding);

datahandle.setData(data);
end
