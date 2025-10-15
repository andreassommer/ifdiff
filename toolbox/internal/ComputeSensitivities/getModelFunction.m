function functionHandle = getModelFunction(datahandle, modelStage)
%functionHandle = GETMODELFUNCTION(datahandle, modelStage)
%
%Find an existing model function or create a new one based on a model stage.
%
%INPUT:
%   datahandle - Contains signature corresponding to the model stage.
%       struct
%
%   modelStage - Number of the model as encountered during initial computation of solution.
%       positive integer
%
%OUTPUT:
%   functionHandle - Handle to the requested model function.
%       function_handle

data = datahandle.getData();
factory = data.codeGen.modelFactory;

rhsName       = data.mtreeplus{2, 1};
dataSignature = data.SWP_detection.signature;
switchCond    = dataSignature.switch_cond{modelStage};
ctrlifIndex   = dataSignature.ctrlif_index{modelStage};
functionIndex = dataSignature.function_index{modelStage};
signature     = BranchingSignature( ...
    rhsName, ...
    switchCond, ...
    ctrlifIndex, ...
    functionIndex);

[functionHandle, collisionIndex] = factory.findExisting(signature);
if isempty(functionHandle)
    functionHandle = factory.createNew(signature, collisionIndex);
end
end
