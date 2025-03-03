function [idxMtreeExport, exportMtreeArray, exportFunctionNameArray] = processFunctionIndex(this, functionIndex, exportMtreeArray, exportFunctionNameArray, rhsNewName, helperIndexToIdxMtreeMap, replaceByReturn)
% functionIndex - 1xn array of unsigned ints
% idxMtreeCtrlif - idx of the mtree where the ctrlif is located

idxMtreeCaller = 1;
idxMtreeExport = 1;

% Ctrlif is in the RHS, nothing left to do
if isequal(functionIndex, 0)
    return
end

for idxFunctionIndex = 1:length(functionIndex)
    helperFunctionIndex = functionIndex(1:idxFunctionIndex);

    % Find out which function is called
    idxMtreeFunction = this.functionIndexToIdxMtree(helperFunctionIndex(end), idxMtreeCaller);
    helperFunctionInfo = this.getHelperFunctionCallInfo(idxMtreeCaller, helperFunctionIndex(end));

    % Check if this helper function call was already processed before
    idxMtreeHelperNew = length(exportMtreeArray) + 1;
    idxMtreeHelper = helperIndexToIdxMtreeMap.get(helperFunctionIndex, idxMtreeHelperNew);
    if isempty(idxMtreeHelper)
        idxMtreeHelper = idxMtreeHelperNew;
        % Create new helper function
        helperNewName = [rhsNewName '_' num2str(idxMtreeHelper)];
        exportMtreeArray{idxMtreeHelper} = createHelperSwitchingFunction(this.mtreeArray{idxMtreeFunction}, helperNewName);
        exportFunctionNameArray{idxMtreeHelper} = helperNewName;

        % Adjust function call
        exportMtreeArray{idxMtreeExport} = SwitchingFunctionFactory.adjustFunctionCall( ...
            exportMtreeArray{idxMtreeExport}, ...
            helperNewName, ...
            helperFunctionInfo.rIndexCall, ...
            helperFunctionInfo.rIndexArgs(3) ...
            );
    end

    % On the last ctrlif, set the helper function call as the return value of the caller
    if replaceByReturn
        exportMtreeArray{idxMtreeExport} = SwitchingFunctionFactory.setFunctionCallAsReturnValue( ...
            exportMtreeArray{idxMtreeExport}, ...
            helperFunctionInfo.rIndexEquals, ...
            helperFunctionInfo.rIndexExpr ...
            );
    end

    % Update mtreeIndex
    idxMtreeCaller = idxMtreeFunction;
    idxMtreeExport = idxMtreeHelper;
end
end
