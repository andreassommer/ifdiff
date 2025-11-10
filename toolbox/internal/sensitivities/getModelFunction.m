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

signature = data.SWP_detection.signature{modelStage};

[functionHandle, collisionIndex] = factory.findExisting(signature);
if isempty(functionHandle)
    functionHandle = factory.createNew(signature, collisionIndex);
end
end
