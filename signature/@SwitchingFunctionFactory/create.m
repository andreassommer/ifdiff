function switchingFunctionHandle = create(this, signature, collisionIndex, varargin)
%CREATESWITCHINGFCNFROMSIGNATURE    Create new switching function from a signature.


if nargin > 3
    ctrljumpArgs = varargin{1};
    isJump = true;
else
    isJump = false;
end

exportMtreeArray = this.functionData.mtreeArray(1);
% Update RHS name
rhsNewName = createSwitchingFunctionName(this.namePrefix, this.functionData.functionNameArray{1}, signature.hash, collisionIndex);

% Exported functions are named as: <rhsNewName>_<export mtree index>
% RHS always gets index 1 in the export mtrees
exportMtreeArray{1} = mtree_changeFcnName(exportMtreeArray{1}, getExportFunctionName(rhsNewName, 1));

% Determine in which function each ctrlif was called
% Also copy mtrees of relevant helper functions and adjust function calls along the way
numCtrlif = length(signature.ctrlif_index);
funIter = FunctionIterator(this.functionData);

for idxCtrlif = 1:numCtrlif
    funIter = funIter.reset(signature.function_index{idxCtrlif});

    while true
        funIter = funIter.next();
        if funIter.stop
            break
        end

        helperFunctionInfo = this.functionData.getHelperFunctionCallInfo(funIter.idxMtreeCallerOriginal, funIter.functionIndex);

        if funIter.new
            % Create new helper
            helperName = getExportFunctionName(rhsNewName, funIter.idxMtreeCallExport);
            exportMtreeArray{funIter.idxMtreeCallExport} = createHelperSwitchingFunction(this.functionData.mtreeArray{funIter.idxMtreeCallOriginal}, helperName);

            % Also adjust the function name in the caller
            exportMtreeArray{funIter.idxMtreeCallerExport} = SwitchingFunctionFactory.adjustFunctionCall( ...
                exportMtreeArray{funIter.idxMtreeCallerExport}, ...
                helperName, ...
                helperFunctionInfo.rIndexCall, ...
                helperFunctionInfo.rIndexArgs(3) ...
                );
        end

        % On the last ctrlif, set the helper function call as the return value of the caller
        if idxCtrlif == numCtrlif
            exportMtreeArray{funIter.idxMtreeCallerExport} = SwitchingFunctionFactory.setFunctionCallAsReturnValue( ...
                exportMtreeArray{funIter.idxMtreeCallerExport}, ...
                this.outputName, ...
                helperFunctionInfo.rIndexEquals, ...
                helperFunctionInfo.rIndexExpr ...
                );
        end
    end

    % For jump functions, all ctrlifs are replaced by their true or false part.
    % For switching functions, all ctrlifs except for the last are replaced by their true or false part.
    if isJump || idxCtrlif ~= numCtrlif
        exportMtreeArray{funIter.idxMtreeCallerExport} = replaceCtrlifByTrueOrFalse( ...
            exportMtreeArray{funIter.idxMtreeCallerExport}, ...
            signature.ctrlif_index(idxCtrlif), ...
            signature.switch_cond(idxCtrlif) ...
            );
    end

    % The last ctrlif is treated in a special way which differs for switching and jump functions.
    if idxCtrlif == numCtrlif
        if isJump
            exportMtreeArray{funIter.idxMtreeCallerExport} = replaceCtrljumpByReturn( ...
                exportMtreeArray{funIter.idxMtreeCallerExport}, ...
                signature.ctrlif_index(end), ...
                ctrljumpArgs ...
                );
        else
            exportMtreeArray{funIter.idxMtreeCallerExport} = replaceCtrlifByReturn( ...
                exportMtreeArray{funIter.idxMtreeCallerExport}, ...
                this.outputName, ...
                signature.ctrlif_index(end) ...
                );
        end
    end
end


for idxExportMtree = 1:length(exportMtreeArray)
    % Write the mtrees to files
    filepath = [getExportFunctionName(rhsNewName, idxExportMtree), '.m'];
    filepath = fullfile(this.writePath, filepath);
    file = fopen(filepath, 'w');
    % Add a signature header as comment
    fprintf(file, '%%%s\n%s\n', signature.str, exportMtreeArray{idxExportMtree}.tree2str);
    fclose(file);
end

% Return function handle to the main switching function
switchingFunctionHandle = str2func(getExportFunctionName(rhsNewName, 1));
end
