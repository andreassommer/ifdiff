function switchingFunctionHandle = create(this, signature, collisionIndex, varargin)
%switchingFunctionHandle = CREATE(this, signature, collisionIndex)
%switchingFunctionHandle = CREATE(this, signature, collisionIndex, ctrljumpInfo)
%
%Create a new switching/jump function and necessary helper functions based on a signature.
%The source code of the functions will be written to .m files.
%
%INPUT:
%   signature - Signature corresponding to the function that should be created.
%       SwitchingFunctionSignature
%
%   collisionIndex - Integer added as a suffix to the name of the new function
%   to avoid name clashes when encountering hash collisions in the signature.
%       scalar positive integer
%
%   ctrljumpInfo - (Optional) Contains information that ties ctrlif indices to ctrljump expressions.
%   If provided, this function will create a jump function instead of a switching function.
%       3xN array of integers
%
%OUTPUT:
%   switchingFunctionHandle - Handle to the main (i.e. not helper) function of the newly created function.
%       function handle
%
%See also SWITCHINGFUNCTIONFACTORY, SWITCHINGFUNCTIONSIGNATURE, SOLVEODE, SOLVEODE_GETJUMPINDICES


% Check whether we should create a switching function or a jump function.
if nargin > 3
    ctrljumpInfo = varargin{1};
    isJump = true;
else
    isJump = false;
end

% We have to create one main function and an arbitrary number of helper functions depending on the function index.
% Since we don't know the number in advance and may need to edit functions multiple times, store mtrees in a cell array.
% We also assign a unique integer ID to each exported function which is equal to its index in the cell array.
% Note that the RHS, which will become the main function, is always assigned index 1.
exportMtreeArray = this.functionData.mtreeArray(1);

% All exported functions are named as: <switchingFunctionName>_<exportID>
rhsName = this.functionData.functionNameArray{1};
switchingFunctionName = createSwitchingFunctionName(this.namePrefix, rhsName, signature.hash, collisionIndex);

% Update name of main function
mainFunctionName = getExportFunctionName(switchingFunctionName, 1);
exportMtreeArray{1} = mtree_changeFcnName(exportMtreeArray{1}, mainFunctionName);

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
            helperName = getExportFunctionName(switchingFunctionName, funIter.idxMtreeCallExport);
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
                ctrljumpInfo ...
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
    filepath = [getExportFunctionName(switchingFunctionName, idxExportMtree), '.m'];
    filepath = fullfile(this.writePath, filepath);
    file = fopen(filepath, 'w');
    % Add a signature header as comment
    fprintf(file, '%%%s\n%s\n', signature.str, exportMtreeArray{idxExportMtree}.tree2str);
    fclose(file);
end

% Return function handle to the main switching function
switchingFunctionHandle = str2func(getExportFunctionName(switchingFunctionName, 1));
end
