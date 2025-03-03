function switchingFunctionHandle = create(this, signature, collisionIndex)
%CREATESWITCHINGFCNFROMSIGNATURE    Create new switching function from a signature.


exportMtreeArray = this.mtreeArray(1);
% Update RHS name
rhsNewName = createSwitchingFunctionName(this.functionNameArray{1}, signature.hash, collisionIndex);
exportMtreeArray{1} = mtree_changeFcnName(exportMtreeArray{1}, rhsNewName);
exportFunctionNameArray{1} = rhsNewName;

helperIndexToIdxMtreeMap = HashMap(@(key) numericJoin(key, '-'));


% Determine in which function each ctrlif was called
% Also copy mtrees of relevant helper functions and adjust function calls along the way
numCtrlif = length(signature.ctrlif_index);
for idxCtrlif = 1:numCtrlif
    functionIndex = signature.function_index{idxCtrlif};
    [idxMtreeCtrlif, exportMtreeArray, exportFunctionNameArray] ...
        = this.processFunctionIndex(functionIndex, exportMtreeArray, exportFunctionNameArray, rhsNewName, helperIndexToIdxMtreeMap, idxCtrlif == numCtrlif);

    % Replace the ctrlif
    if idxCtrlif == numCtrlif
        exportMtreeArray{idxMtreeCtrlif} = replaceCtrlifByReturn(exportMtreeArray{idxMtreeCtrlif}, signature.ctrlif_index(end));
    else
        exportMtreeArray{idxMtreeCtrlif} = replaceCtrlifByTrueOrFalse( ...
            exportMtreeArray{idxMtreeCtrlif}, ...
            signature.ctrlif_index(idxCtrlif), ...
            signature.switch_cond(idxCtrlif) ...
            );
    end
end


for idxExportMtree = 1:length(exportMtreeArray)
    % Write the mtrees to files
    filepath = [exportFunctionNameArray{idxExportMtree} '.m'];
    filepath = fullfile(this.writePath, filepath);
    file = fopen(filepath, 'w');
    % Add a signature header as comment
    fprintf(file, '%%%s\n%s\n', signature.str, exportMtreeArray{idxExportMtree}.tree2str);
    fclose(file);
end

% Return function handle to the main switching function
switchingFunctionHandle = str2func(rhsNewName);

end
