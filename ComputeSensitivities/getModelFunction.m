function functionHandle = getModelFunction(datahandle, modelStage)

data = datahandle.getData();
factory = data.codeGen.modelFactory;

rhsName       = data.mtreeplus{2, 1};
dataSignature = data.SWP_detection.signature;
switchCond    = dataSignature.switch_cond{modelStage};
ctrlifIndex   = dataSignature.ctrlif_index{modelStage};
functionIndex = dataSignature.function_index{modelStage};
signature     = SwitchingFunctionSignature( ...
    rhsName, ...
    switchCond, ...
    ctrlifIndex, ...
    functionIndex);

[functionHandle, collisionIndex] = factory.findExisting(signature);
if isempty(functionHandle)
    functionHandle = factory.createNew(signature, collisionIndex);
end
end

