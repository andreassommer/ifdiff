function dy = evaluateRHSForSignature(datahandle, t, y, p, ctrlif_index, function_index, switch_cond)
% dy = evaluateRHSForSignature(datahandle, t, y, p, ctrlif_index, function_index, switch_cond)
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
%   ctrlif_index:   the signature's crtlif_index
%       
%   function_index: the signature's function_index
%
%   switch_cond:    the signature's switch_cond
%
% OUTPUT:
%   dy:             Output of the preprocessed right-hand-side
data = datahandle.getData();
config = makeConfig();

% forced branching signature
data.forcedBranching.switch_cond_forcedBranching    = switch_cond; 
data.forcedBranching.ctrlif_index_forcedBranching   = ctrlif_index; 
data.forcedBranching.function_index_forcedBranching = function_index; 

% preallocate arrays to store current signature as it would be without forced branching
data.forcedBranching.switch_cond    = zeros(1,length(data.forcedBranching.switch_cond_forcedBranching));
data.forcedBranching.ctrlif_index   = zeros(1,length(data.forcedBranching.ctrlif_index_forcedBranching));
data.forcedBranching.function_index = cell(length(data.forcedBranching.function_index_forcedBranching),1);

% counter from the ctrlif
data.forcedBranching.ctrlifCounter = 0;
data.caseCtrlif = config.caseCtrlif.forcedBranching; % case forced branching

datahandle.setData(data);

dy = datahandle.getData().integratorSettings.preprocessed_rhs(datahandle,t,y,p);

% cleanup
data = datahandle.getData();
data.caseCtrlif = config.caseCtrlif.default; % default case
end