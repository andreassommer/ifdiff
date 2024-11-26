function switchingFunctionHandle = create(this, signature)
%CREATESWITCHINGFCNFROMSIGNATURE    Create new switching function from a signature.


% Local copy of the mtrees for modification since we don't want to overwrite the originals
mtreeArray = this.mtreeArray;

% Only relevant helper functions are exported
isMtreeModified = false(1, length(mtreeArray));
isMtreeModified(1) = true;

% We always export the RHS function, so update its name now
rhsNewName = createSwitchingFunctionName(this.functionNameArray{1}, signature.hash);
mtreeArray{1} = mtree_changeFcnName(mtreeArray{1}, rhsNewName);

% All ctrlifs before the ctrlif whose condition value has changed are replaced by their true/false part
numCtrlif = length(signature.ctrlif_index);
for idxCtrlif = 1:numCtrlif-1
    % Always start by looking at the RHS function
    idxCallerMtree = 1;
    % Check if the actual ctrlif was called in the RHS or a helper function
    functionIndexArray = signature.function_index{idxCtrlif};
    if functionIndexArray(1) ~= 0
        for idxFunctionIndex = 1:length(functionIndexArray)
            functionIndex = functionIndexArray(idxFunctionIndex);
            idxCalleeMtree = this.functionIndexToIdxMtree(functionIndex, idxCallerMtree);

            helperFunctionInfo = this.getHelperFunctionCallInfo(idxCallerMtree);
            idxHelperFunctionInfo = helperFunctionInfo.functionIndexToIdxRIndex(functionIndex);
            
            newHelperFunctionName = createSwitchingFunctionName(this.functionNameArray{idxCalleeMtree}, signature.hash);
            mtreeArray{idxCallerMtree} = SwitchingFunctionFactory.adjustFunctionCall( ...
                mtreeArray{idxCallerMtree}, ...
                newHelperFunctionName, ...
                helperFunctionInfo.rIndexCall(idxHelperFunctionInfo), ...
                helperFunctionInfo.rIndexArgs(idxHelperFunctionInfo, 3) ...
            );


            % If the helper function doesn't exist yet, then create it
            if ~isMtreeModified(idxCalleeMtree)
                mtreeArray{idxCalleeMtree} = createHelperSwitchingFunction(mtreeArray{idxCalleeMtree}, newHelperFunctionName);
                isMtreeModified(idxCalleeMtree) = true;
            end
            % Proceed with next function_index and corresponding caller mtree
            idxCallerMtree = idxCalleeMtree;
            idxCalleeMtree = [];
        end
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
functionIndexArray = signature.function_index{end};
if functionIndexArray(1) ~= 0
    for idxFunctionIndex = 1:length(functionIndexArray)
        functionIndex = functionIndexArray(idxFunctionIndex);
        idxCalleeMtree = this.functionIndexToIdxMtree(functionIndex, idxCallerMtree);

        helperFunctionInfo = this.getHelperFunctionCallInfo(idxCallerMtree);
        idxHelperFunctionInfo = helperFunctionInfo.functionIndexToIdxRIndex(functionIndex);
        
        newHelperFunctionName = createSwitchingFunctionName(this.functionNameArray{idxCalleeMtree}, signature.hash);
        mtreeArray{idxCallerMtree} = SwitchingFunctionFactory.adjustFunctionCall( ...
            mtreeArray{idxCallerMtree}, ...
            newHelperFunctionName, ...
            helperFunctionInfo.rIndexCall(idxHelperFunctionInfo), ...
            helperFunctionInfo.rIndexArgs(idxHelperFunctionInfo, 3) ...
        );


        % If the helper function doesn't exist yet, then create it
        if ~isMtreeModified(idxCalleeMtree)
            mtreeArray{idxCalleeMtree} = createHelperSwitchingFunction(mtreeArray{idxCalleeMtree}, newHelperFunctionName);
            isMtreeModified(idxCalleeMtree) = true;
        end

        % For the caller mtree, we can set the result of the function call as the output
        mtreeArray{idxCallerMtree} = SwitchingFunctionFactory.setFunctionCallAsReturnValue( ...
            mtreeArray{idxCallerMtree}, ...
            helperFunctionInfo.rIndexEquals(idxHelperFunctionInfo), ...
            helperFunctionInfo.rIndexExpr(idxHelperFunctionInfo));

        % Proceed with next function_index and corresponding caller mtree
        idxCallerMtree = idxCalleeMtree;
        idxCalleeMtree = [];
    end
end
mtreeArray{idxCallerMtree} = replaceCtrlifByReturn(mtreeArray{idxCallerMtree}, signature.ctrlif_index(end));


% Remove variables that do not contribute to the return value for all functions
exportMtree = find(isMtreeModified);
for idxMtree=exportMtree
    sortedMtree = mtreeplus(mtreeArray{idxMtree}.tree2str);
    mtreeArray{idxMtree} = deleteUnusedParameters(sortedMtree);
end

% Export the created mtrees to files
for idxMtree=exportMtree
    filename = [createSwitchingFunctionName(this.functionNameArray{idxMtree}, signature.hash), '.m'];

    filepath = fullfile(this.writePath, filename);
    file = fopen(filepath, 'w');
    fprintf(file, '%%%s\n%s\n', signature.str, mtreeArray{idxMtree}.tree2str);
    fclose(file);
end

switchingFunctionHandle = str2func(rhsNewName);
end
