function switchingFunctionHandle = create(this, signature, collisionIndex, varargin)
%CREATESWITCHINGFCNFROMSIGNATURE    Create new switching function from a signature.

config = makeConfig();

if nargin > 3
    ctrljumpArgs = varargin{1};
    isJump = true;
else
    isJump = false;
end

exportMtreeArray = this.functionData.mtreeArray(1);
% Update RHS name
if isJump
    namePrefix = config.jump.jumpFunctionNamePrefix;
else
    namePrefix = config.switchingFunctionNamePrefix;
end
rhsNewName = createSwitchingFunctionName(namePrefix, this.functionData.functionNameArray{1}, signature.hash, collisionIndex);
exportMtreeArray{1} = mtree_changeFcnName(exportMtreeArray{1}, rhsNewName);
exportFunctionNameArray{1} = rhsNewName;

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
            helperName = [rhsNewName '_' num2str(funIter.idxMtreeCallExport)];
            exportFunctionNameArray{funIter.idxMtreeCallExport} = helperName;
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
                helperFunctionInfo.rIndexEquals, ...
                helperFunctionInfo.rIndexExpr ...
                );
        end
    end

    % Replace the ctrlif
    if isJump
        exportMtreeArray{funIter.idxMtreeCallerExport} = replaceCtrlifByTrueOrFalse( ...
            exportMtreeArray{funIter.idxMtreeCallerExport}, ...
            signature.ctrlif_index(idxCtrlif), ...
            signature.switch_cond(idxCtrlif) ...
            );
        if idxCtrlif == numCtrlif
            exportMtreeArray{funIter.idxMtreeCallerExport} = replaceCtrljumpByReturn( ...
                exportMtreeArray{funIter.idxMtreeCallerExport}, ...
                signature.ctrlif_index(end), ...
                ctrljumpArgs ...
                );
        end
    else
        if idxCtrlif == numCtrlif
            exportMtreeArray{funIter.idxMtreeCallerExport} = replaceCtrlifByReturn( ...
                exportMtreeArray{funIter.idxMtreeCallerExport}, ...
                signature.ctrlif_index(end) ...
                );
        else
            exportMtreeArray{funIter.idxMtreeCallerExport} = replaceCtrlifByTrueOrFalse( ...
                exportMtreeArray{funIter.idxMtreeCallerExport}, ...
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
