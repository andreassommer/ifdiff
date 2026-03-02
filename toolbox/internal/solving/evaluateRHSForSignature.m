function dy = evaluateRHSForSignature(datahandle, t, y, p, signature)
% dy = evaluateRHSForSignature(datahandle, t, y, p, signature)
%
% For a given signature, evaluates the preprocessed right-hand-side in
% datahandle with activated forced-branching for the given (t,y,p).
%
% INPUT:
%   datahandle:     datahandle containing the preprocessed right-hand-side
%                   (i.e., datahandle.integratorSettings.preprocessed_rhs)
%                       handle
%
%   t:              time variable
%                       scalar
%   y:              state variable
%                       scalar or array
%   p:              parameters
%                       scalar or array
%
%   signature:      signature used for forced branching evaluation
%                       BranchingSignature
%
% OUTPUT:
%   dy:             Output of the preprocessed right-hand-side

config = makeConfig();
data = datahandle.getData();
oldData = data;

% Set forced branching signature
data.forcedBranching.switch_cond_forcedBranching    = signature.switchCond;
data.forcedBranching.ctrlif_index_forcedBranching   = signature.ctrlifIndex;
data.forcedBranching.function_index_forcedBranching = signature.functionIndex;

% Ensure ctrlif counter is reset
data.forcedBranching.ctrlifCounter = 0;
% Enable forced branching mode but without storing the evaluated signature (we only care about getting output dy here).
data.caseCtrlif = config.caseCtrlif.extendODEuntilSwitch;

% Evaluate RHS with given signature
datahandle.setData(data);
dy = data.integratorSettings.preprocessed_rhs(datahandle, t, y, p);

% Undo any changes made to the datahandle
datahandle.setData(oldData);
end
