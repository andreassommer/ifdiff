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

% Overview of the algorithm:
% The output of the switching function should be the condition contained within the last ctrlif in the signature,
% since this is the ctrlif whose condition has flipped and the condition is in normal form (i.e. cond >= 0).
%
% Also, we want the switching function to only contain statements that are required to compute the switching value,
% because it may be called many times during the root finding algorithm used to compute the switching point.
%
% To achieve this, we first replace all ctrlifs called before the last ctrlif with their fixed true or false part.
%
% However, ctrlifs may be contained within helper functions, so we first need to find the mtree of each ctrlif.
%
% Additionally, the same ctrlif may be called multiple times.
% To deal with this, we create a copy of a helper function for each unique call sequence belonging to this function.
%
% Finally, the last ctrlif, and all helper function leading to it have to be replaced by appropriate return statements,
% to simplify all functions and acquire the switch condition as the output of the main switching function.
%
% A similar procedure applies to jump functions with the main difference that the output value is obtained differently.

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

% Update name of main function.
mainFunctionName = getExportFunctionName(switchingFunctionName, 1);
exportMtreeArray{1} = mtree_changeFcnName(exportMtreeArray{1}, mainFunctionName);

numCtrlif = length(signature.ctrlifIndex);
funcIter = FunctionIterator(this.functionData);

for idxCtrlif = 1:numCtrlif
    funcIter = funcIter.resetIteration(signature.functionIndex{idxCtrlif});
    % Iterate over helper function calls preceding the ctrlif call to find the mtree of the ctrlif.
    % Along the way, create copies of helper functions and adjust helper function calls if necessary.
    while true
        funcIter = funcIter.next();
        if funcIter.stop
            % No more helper function calls, we have found the mtree of the ctrlif.
            break
        end

        helperCallInfo = this.functionData.getHelperCallInfo(funcIter.idxMtreeCallerOriginal, funcIter.functionIndex);

        if funcIter.new
            % Create new helper function.
            helperName = getExportFunctionName(switchingFunctionName, funcIter.idxMtreeCallExport);
            exportMtreeArray{funcIter.idxMtreeCallExport} = createHelperSwitchingFunction( ...
                this.functionData.mtreeArray{funcIter.idxMtreeCallOriginal}, ...
                helperName ...
                );

            % Adjust the helper function call in the caller mtree to match the newly created helper function.
            exportMtreeArray{funcIter.idxMtreeCallerExport} = adjustHelperFunctionCall( ...
                exportMtreeArray{funcIter.idxMtreeCallerExport}, ...
                helperName, ...
                helperCallInfo.rIndexCall, ...
                helperCallInfo.rIndexArgs(3) ...
                );
        end

        % On the last ctrlif, set the helper function call as the return value of the caller.
        if idxCtrlif == numCtrlif
            exportMtreeArray{funcIter.idxMtreeCallerExport} = setFunctionCallAsReturnValue( ...
                exportMtreeArray{funcIter.idxMtreeCallerExport}, ...
                this.outputName, ...
                helperCallInfo.rIndexEquals, ...
                helperCallInfo.rIndexExpr ...
                );
        end
    end

    ctrlifCallInfo = this.functionData.getCtrlifCallInfo(funcIter.idxMtreeCallerOriginal, signature.ctrlifIndex(idxCtrlif));

    % For jump functions: All ctrlifs are replaced by their true or false part.
    % For switching functions: All ctrlifs except for the last are replaced by their true or false part.
    if isJump || idxCtrlif ~= numCtrlif
        % True part is stored in the second argument of the ctrlif, false part in the third.
        if signature.switchCond(idxCtrlif)
            idxArg = 2;
        else
            idxArg = 3;
        end

        exportMtreeArray{funcIter.idxMtreeCallerExport} = replaceCtrlifByTrueOrFalse( ...
            exportMtreeArray{funcIter.idxMtreeCallerExport}, ...
            ctrlifCallInfo.rIndexEquals, ...
            ctrlifCallInfo.rIndexArgs(idxArg) ...
            );
    end

    % The last ctrlif is treated in a special way which differs for switching and jump functions.
    if idxCtrlif == numCtrlif
        if isJump
            exportMtreeArray{funcIter.idxMtreeCallerExport} = replaceCtrljumpByReturn( ...
                exportMtreeArray{funcIter.idxMtreeCallerExport}, ...
                signature.ctrlifIndex(end), ...
                ctrljumpInfo ...
                );
        else
            exportMtreeArray{funcIter.idxMtreeCallerExport} = replaceCtrlifByReturn( ...
                exportMtreeArray{funcIter.idxMtreeCallerExport}, ...
                this.outputName, ...
                ctrlifCallInfo.rIndexEquals, ...
                ctrlifCallInfo.rIndexExpr, ...
                ctrlifCallInfo.rIndexArgs(1) ...
                );
        end
    end
end

% Export main function and any new helper function mtrees to actual .m files.
exportSwitchingFunctions(exportMtreeArray, this.writePath, switchingFunctionName, signature.str);

% Return function handle to the main function.
switchingFunctionHandle = str2func(getExportFunctionName(switchingFunctionName, 1));
end
