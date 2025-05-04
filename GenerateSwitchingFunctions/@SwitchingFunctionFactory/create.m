function switchingFunctionHandle = create(this, signature, collisionIndex, varargin)
%switchingFunctionHandle = this.CREATE(signature, collisionIndex)
%switchingFunctionHandle = this.CREATE(signature, collisionIndex, ctrljumpInfo)
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
numCtrlif = length(signature.ctrlifIndex);
funIter = FunctionIterator(this.functionData);

for idxCtrlif = 1:numCtrlif
    funIter = funIter.reset(signature.functionIndex{idxCtrlif});

    while true
        funIter = funIter.next();
        if funIter.stop
            break
        end

        helperCallInfo = this.functionData.getHelperCallInfo(funIter.idxMtreeCallerOriginal, funIter.functionIndex);

        if funIter.new
            % Create new helper
            helperName = getExportFunctionName(switchingFunctionName, funIter.idxMtreeCallExport);
            exportMtreeArray{funIter.idxMtreeCallExport} = createHelperSwitchingFunction(this.functionData.mtreeArray{funIter.idxMtreeCallOriginal}, helperName);

            % Also adjust the function name in the caller
            exportMtreeArray{funIter.idxMtreeCallerExport} = adjustHelperFunctionCall( ...
                exportMtreeArray{funIter.idxMtreeCallerExport}, ...
                helperName, ...
                helperCallInfo.rIndexCall, ...
                helperCallInfo.rIndexArgs(3) ...
                );
        end

        % On the last ctrlif, set the helper function call as the return value of the caller
        if idxCtrlif == numCtrlif
            exportMtreeArray{funIter.idxMtreeCallerExport} = setFunctionCallAsReturnValue( ...
                exportMtreeArray{funIter.idxMtreeCallerExport}, ...
                this.outputName, ...
                helperCallInfo.rIndexEquals, ...
                helperCallInfo.rIndexExpr ...
                );
        end
    end

    ctrlifCallInfo = this.functionData.getCtrlifCallInfo(funIter.idxMtreeCallerOriginal, signature.ctrlifIndex(idxCtrlif));

    % For jump functions, all ctrlifs are replaced by their true or false part.
    % For switching functions, all ctrlifs except for the last are replaced by their true or false part.
    if isJump || idxCtrlif ~= numCtrlif
        % True part is stored in the second argument, false part in the third.
        if signature.switchCond(idxCtrlif)
            idxArg = 2;
        else
            idxArg = 3;
        end

        exportMtreeArray{funIter.idxMtreeCallerExport} = replaceCtrlifByTrueOrFalse( ...
            exportMtreeArray{funIter.idxMtreeCallerExport}, ...
            ctrlifCallInfo.rIndexEquals, ...
            ctrlifCallInfo.rIndexArgs(idxArg) ...
            );
    end

    % The last ctrlif is treated in a special way which differs for switching and jump functions.
    if idxCtrlif == numCtrlif
        if isJump
            exportMtreeArray{funIter.idxMtreeCallerExport} = replaceCtrljumpByReturn( ...
                exportMtreeArray{funIter.idxMtreeCallerExport}, ...
                signature.ctrlifIndex(end), ...
                ctrljumpInfo ...
                );
        else
            exportMtreeArray{funIter.idxMtreeCallerExport} = replaceCtrlifByReturn( ...
                exportMtreeArray{funIter.idxMtreeCallerExport}, ...
                this.outputName, ...
                signature.ctrlifIndex(end) ...
                );
        end
    end
end

% Write function mtrees to files
exportSwitchingFunctions(exportMtreeArray, this.writePath, switchingFunctionName, signature.str);

% Return function handle to the main switching function
switchingFunctionHandle = str2func(getExportFunctionName(switchingFunctionName, 1));
end
