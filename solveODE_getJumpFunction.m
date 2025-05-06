function jumpFunctionHandle = solveODE_getJumpFunction(datahandle, factory, idxSignatureJumpCtrlif)
%SOLVEODE_GETJUMPFUNCTION(datahandle, factory, idxSignatureJumpCtrlif)
%
%Retrieve the jump function for the jump detected in the last integration step.
%
%INPUT:
%   datahandle - Datahandle containing the signature information for the last integration step.
%       function handle
%
%   factory - Switching function factory used to find existing jump functions and create new ones.
%       SwitchingFunctionFactory
%
%   idxSignatureJumpCtrlif - Signature index of the ctrlif associated with the jump.
%       positive integer
%
%   The following datahandle fields are relevant:
%   SWP_detection.switch_cond_t1 - Switch conditions observed before the jump.
%       1xM array of positive integers
%
%   SWP_detection.ctrlif_index_t1 - Ctrlif indices observed before the jump.
%       1xM array of positive integers
%
%   SWP_detection.function_index_t1 - Function indices observed before the jump.
%       Mx1 cell array of 1x? arrays of positive integers
%
%   SWP_detection.jumpConditions - Contains information that ties ctrlif indices to ctrljump expressions.
%       3xN array of integers
%
%OUTPUT:
%   jumpFunctionHandle - Handle to the main jump function for the jump detected in the last integration step.
%       function handle
%
%See also SWITCHINGFUNCTIONFACTORY

data = datahandle.getData();

% Prepare signature.
signature = SwitchingFunctionSignature( ...
    data.mtreeplus{2,1}, ...
    data.SWP_detection.switch_cond_t1(1:idxSignatureJumpCtrlif), ...
    data.SWP_detection.ctrlif_index_t1(1:idxSignatureJumpCtrlif), ...
    data.SWP_detection.function_index_t1(1:idxSignatureJumpCtrlif) ...
    );
% Check if jump function exists or create a new one otherwise.
[jumpFunctionHandle, collisionIndex] = factory.findExisting(signature);
if isempty(jumpFunctionHandle)
    jumpFunctionHandle = factory.createNew(signature, collisionIndex, data.SWP_detection.jumpConditions);
end
end
