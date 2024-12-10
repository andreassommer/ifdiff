function switchingFunctionHandle = create(this, signature, collisionIndex)
%CREATESWITCHINGFCNFROMSIGNATURE    Create new switching function from a signature.


% Local copy of the mtrees for modification since we don't want to overwrite the originals
mtreeArray = this.mtreeArray;

% Only relevant helper functions are exported
isMtreeModified = false(1, length(mtreeArray));
isMtreeModified(1) = true;

% We always export the RHS function, so update its name now
rhsNewName = createSwitchingFunctionName(this.functionNameArray{1}, signature.hash, collisionIndex);
mtreeArray{1} = mtree_changeFcnName(mtreeArray{1}, rhsNewName);

% Processed function calls
processedFunctionIndexSet = 0; % 0 means the ctrlif call occured in the RHS function

% All ctrlifs before the ctrlif whose condition value has changed are replaced by their true/false part
numCtrlif = length(signature.ctrlif_index);
for idxCtrlif = 1:numCtrlif-1
    % Always start by looking at the RHS function
    idxCallerMtree = 1;
    % Check if the actual ctrlif was called in the RHS or a helper function
    for functionIndex = signature.function_index{idxCtrlif}
        if functionIndex == 0, break, end
        if ismember(functionIndex, processedFunctionIndexSet)
            idxCallerMtree = this.functionIndexToIdxMtree(functionIndex, idxCallerMtree);
            continue
        end

        [mtreeArray{idxCallerMtree}, idxMtreeFunction] = this.processFunctionIndex( ...
            functionIndex, idxCallerMtree, mtreeArray{idxCallerMtree}, true, false, signature.hash, collisionIndex ...
            );
        
        isMtreeModified(idxMtreeFunction) = true;
        processedFunctionIndexSet = union(processedFunctionIndexSet, functionIndex);

        idxCallerMtree = idxMtreeFunction;
    end
    % TODO: Clean up the replaceCtrlifByTrueOrFalse function
    mtreeArray{idxCallerMtree} = replaceCtrlifByTrueOrFalse( ...
        mtreeArray{idxCallerMtree}, ...
        signature.ctrlif_index(idxCtrlif), ...
        signature.switch_cond(idxCtrlif) ...
    );
end

% Replace the last ctrlif (i.e. the one whose condition value has changed) by a return
% Always start by looking at the RHS function
idxCallerMtree = 1;
% Check if the actual ctrlif was called in the RHS or a helper function
for functionIndex = signature.function_index{end}
    if functionIndex == 0, break, end
    isFunctionCallAdjusted = ismember(functionIndex, processedFunctionIndexSet);

    [mtreeArray{idxCallerMtree}, idxMtreeFunction] = this.processFunctionIndex( ...
        functionIndex, idxCallerMtree, mtreeArray{idxCallerMtree}, ~isFunctionCallAdjusted, true, signature.hash, collisionIndex ...
        );
    
    isMtreeModified(idxMtreeFunction) = true;
    processedFunctionIndexSet = union(processedFunctionIndexSet, functionIndex);
    idxCallerMtree = idxMtreeFunction;
end
mtreeArray{idxCallerMtree} = replaceCtrlifByReturn(mtreeArray{idxCallerMtree}, signature.ctrlif_index(end));


% Remove variables that do not contribute to the return value for all functions
exportMtree = find(isMtreeModified);
for idxMtree=exportMtree
    % Adjust name and remove datahandle, function_index args for helper functions
    if idxMtree ~= 1
        helperFunctionName = createSwitchingFunctionName(this.functionNameArray{idxMtree}, signature.hash);
        mtreeArray{idxMtree} = createHelperSwitchingFunction(mtreeArray{idxMtree}, helperFunctionName);
    end
    sortedMtree = mtreeplus(mtreeArray{idxMtree}.tree2str);
    mtreeArray{idxMtree} = deleteUnusedParameters(sortedMtree);
end

% Export the created mtrees to files
for idxMtree=exportMtree
    if idxMtree == 1
        filename = [rhsNewName '.m'];
    else
        filename = [createSwitchingFunctionName(this.functionNameArray{idxMtree}, signature.hash, collisionIndex), '.m'];
    end

    filepath = fullfile(this.writePath, filename);
    file = fopen(filepath, 'w');
    fprintf(file, '%%%s\n%s\n', signature.str, mtreeArray{idxMtree}.tree2str);
    fclose(file);
end

switchingFunctionHandle = str2func(rhsNewName);
end
