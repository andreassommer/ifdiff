function [A1, A2, A3] = ctrlif_getSignature(datahandle, t, x, varargin)
% function that evaluates the rhs function at a point (t, x) to get the signature.

% The optional argument signature can be used to apply forced branching - then the RHS will be forced to branch
% matching that signature.

config = makeConfig();
data = datahandle.getData();
signaturePassed = nargin > 3;

% get data for reading and writing
% disable switching point detection in ctrlif

if signaturePassed
    signature = varargin{1};
    data.caseCtrlif = config.caseCtrlif.getSignatureChange;
    data.getSignature.switch_cond_forcedBranching = signature.switch_cond;
    data.getSignature.ctrlif_index_forcedBranching = signature.ctrlif_index;
    data.getSignature.function_index_forcedBranching = signature.function_index;
else
    data.caseCtrlif = config.caseCtrlif.getSignature;
end

data.getSignature.ctrlifCounter = 0;

data.getSignature.switch_cond    = [];
data.getSignature.ctrlif_index   = [];
data.getSignature.function_index = {};

datahandle.setData(data);


% evaluate the function at the two borders of the switching interval
feval(...
    data.integratorSettings.preprocessed_rhs, ...
    datahandle, ...
    t, ...
    x, ...
    data.SWP_detection.parameters);


data = datahandle.getData();
index = 1:data.getSignature.ctrlifCounter;

A1 = data.getSignature.switch_cond(1,index);
A2 = data.getSignature.ctrlif_index(1,index);
A3 = data.getSignature.function_index(index,1);
end

