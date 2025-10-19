function this = handleHelperCallsBeforeCtrlif(this, idxCtrlif, isReturn)
%this = this.HANDLEHELPERCALLSBEFORECTRLIF(idxCtrlif, isReturn)
%
%Iterate over helper function calls preceding the ctrlif call to find the mtree of the ctrlif.
%Along the way, create copies of helper functions and adjust helper function calls if necessary.
%
%INPUT:
%   idxCtrlif - Index of the ctrlif to be found in the signature (NOT the ctrlif_index).
%       positive integer
%
%   isReturn - Whether or not function calls should be replaced with return statements.
%       logical
%
%OUTPUT:
%   this.funcIter - Export and original index of the mtree containing the ctrlif.
%       FunctionIterator
%
%   this.exportMtreeArray - Existing mtrees updated for function calls and new mtrees for helper fuctions added.
%       1xN cell array of mtreeplus

this.funcIter = this.funcIter.resetIteration(this.signature.functionIndex{idxCtrlif});
while true
    this.funcIter = this.funcIter.next();
    if this.funcIter.stop
        % No more helper function calls, we have found the mtree of the ctrlif.
        break
    end

    helperCallInfo = this.functionData.getHelperCallInfo( ...
        this.funcIter.idxMtreeCallerOriginal, ...
        this.funcIter.functionIndex);

    if this.funcIter.new
        % Create new helper function.
        helperName = getExportFunctionName(this.functionName, this.funcIter.idxMtreeCallTargetExport);
        this.exportMtreeArray{this.funcIter.idxMtreeCallTargetExport} = createHelperSwitchingFunction( ...
            this.functionData.mtreeArray{this.funcIter.idxMtreeCallTargetOriginal}, ...
            helperName ...
            );

        % Adjust the helper function call in the caller mtree to match the newly created helper function.
        this.exportMtreeArray{this.funcIter.idxMtreeCallerExport} = adjustHelperFunctionCall( ...
            this.exportMtreeArray{this.funcIter.idxMtreeCallerExport}, ...
            helperName, ...
            helperCallInfo.rIndexCall, ...
            helperCallInfo.rIndexArgs(3) ...
            );
    end

    % Set the helper function call as the return value of the caller if required.
    if isReturn
        this.exportMtreeArray{this.funcIter.idxMtreeCallerExport} = setFunctionCallAsReturnValue( ...
            this.exportMtreeArray{this.funcIter.idxMtreeCallerExport}, ...
            this.functionOutputName, ...
            helperCallInfo.rIndexEquals, ...
            helperCallInfo.rIndexExpr ...
            );
    end
end
end
