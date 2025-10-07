function jumpFunctionHandle = solveODE_getJumpFunction(datahandle, idxSignatureJumpCtrlif)
%SOLVEODE_GETJUMPFUNCTION(datahandle, idxSignatureJumpCtrlif)
%
%Retrieve the jump function for the jump detected in the last integration step.
%
%INPUT:
%   datahandle - Datahandle containing the signature information for the last integration step.
%       function handle
%
%   idxSignatureJumpCtrlif - Signature index of the ctrlif associated with the jump.
%       positive integer
%
%   The following datahandle fields are relevant:
%   codeGen.jumpFactory - Jump function factory used to find existing jump functions and create new ones.
%       FixedBranchingFunctionStore
%
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

data = datahandle.getData();
factory = data.codeGen.jumpFactory;

% Prepare signature.
signature = BranchingSignature( ...
    data.mtreeplus{2,1}, ...
    data.SWP_detection.switch_cond_t1(1:idxSignatureJumpCtrlif), ...
    data.SWP_detection.ctrlif_index_t1(1:idxSignatureJumpCtrlif), ...
    data.SWP_detection.function_index_t1(1:idxSignatureJumpCtrlif) ...
    );

% Check if jump function exists or create a new one otherwise.
[jumpFunctionHandle, collisionIndex] = factory.findExisting(signature);
if isempty(jumpFunctionHandle)
    % FIXME: Ugly solution, would be better to store it in functionData upon creation.
    % Should refactor this together with datahandle struct.
    if isempty(factory.functionData.ctrljumpInfo)
        factory.functionData.ctrljumpInfo = data.SWP_detection.jumpConditions;
    end
    jumpFunctionHandle = factory.createNew(signature, collisionIndex);
end
end
