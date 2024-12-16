function switchingFunctionHandle = create(this, signature, collisionIndex)
%CREATESWITCHINGFCNFROMSIGNATURE    Create new switching function from a signature.


exportMtree = this.mtreeArray(1);
% Update RHS name
rhsNewName = createSwitchingFunctionName(this.functionNameArray{1}, signature.hash, collisionIndex);
exportMtree{1} = mtree_changeFcnName(exportMtree{1}, rhsNewName);
exportFunctionNameArray{1} = rhsNewName;

FUNCTION_INDEX_DELIMITER = '-';
functionIndexFullToIdxMtreeMap = containers.Map('KeyType', 'char', 'ValueType', 'int32');


% Determine in which function each ctrlif was called
% Also copy mtrees of relevant helper functions and adjust function calls along the way
numCtrlif = length(signature.ctrlif_index);
for idxCtrlif = 1:numCtrlif
    functionIndex = signature.function_index{idxCtrlif};
    idxMtreeCaller = 1;
    idxMtreeExport = 1;
    for idxFunctionIndex = 1:length(functionIndex)
        % We are in the RHS, nothing left to do
        if functionIndex(1) == 0
            break
        end
        helperIndex = functionIndex(1:idxFunctionIndex);

        % Find out which function is called
        idxMtreeFunction = this.functionIndexToIdxMtree(helperIndex(end), idxMtreeCaller);
        helperFunctionInfo = this.getHelperFunctionCallInfo(idxMtreeCaller, helperIndex(end));

        % Check if this helper function call was already processed before
        idxMtreeHelper = functionIndexFullToIdxMtree(helperIndex);
        if isempty(idxMtreeHelper)
            % Create new helper function
            idxMtreeHelper = length(exportMtree) + 1;
            helperNewName = [rhsNewName '_' num2str(idxMtreeHelper)];
            exportMtree{idxMtreeHelper} = createHelperSwitchingFunction(this.mtreeArray{idxMtreeFunction}, helperNewName);
            exportFunctionNameArray{idxMtreeHelper} = helperNewName;
            % Allow faster lookup
            helperKey = numericJoin(helperIndex, FUNCTION_INDEX_DELIMITER);
            functionIndexFullToIdxMtreeMap(helperKey) = idxMtreeHelper;

            % Adjust function call
            exportMtree{idxMtreeExport} = SwitchingFunctionFactory.adjustFunctionCall( ...
                exportMtree{idxMtreeExport}, ...
                helperNewName, ...
                helperFunctionInfo.rIndexCall, ...
                helperFunctionInfo.rIndexArgs(3) ...
                );
        end

        % On the last ctrlif, set the helper function call as the return value of the caller
        if idxCtrlif == numCtrlif
            exportMtree{idxMtreeExport} = SwitchingFunctionFactory.setFunctionCallAsReturnValue( ...
                exportMtree{idxMtreeExport}, ...
                helperFunctionInfo.rIndexEquals, ...
                helperFunctionInfo.rIndexExpr ...
                );
        end

        % Update mtreeIndex
        idxMtreeCaller = idxMtreeFunction;
        idxMtreeExport = idxMtreeHelper;
    end

    % Replace the ctrlif
    if idxCtrlif == numCtrlif
        exportMtree{idxMtreeExport} = replaceCtrlifByReturn(exportMtree{idxMtreeExport}, signature.ctrlif_index(end));
    else
        exportMtree{idxMtreeExport} = replaceCtrlifByTrueOrFalse( ...
            exportMtree{idxMtreeExport}, ...
            signature.ctrlif_index(idxCtrlif), ...
            signature.switch_cond(idxCtrlif) ...
            );
    end
end


for idxExportMtree = 1:length(exportMtree)
    % Write the mtrees to files
    filepath = [exportFunctionNameArray{idxExportMtree} '.m'];
    filepath = fullfile(this.writePath, filepath);
    file = fopen(filepath, 'w');
    % Add a signature header as comment
    fprintf(file, '%%%s\n%s\n', signature.str, exportMtree{idxExportMtree}.tree2str);
    fclose(file);
end

% Return function handle to the main switching function
switchingFunctionHandle = str2func(rhsNewName);


% HELPER
    function idxMtree = functionIndexFullToIdxMtree(functionIndexFull)
        key = numericJoin(functionIndexFull, FUNCTION_INDEX_DELIMITER);
        if functionIndexFullToIdxMtreeMap.isKey(key)
            idxMtree = functionIndexFullToIdxMtreeMap(key);
        else
            idxMtree = [];
        end
    end
end
