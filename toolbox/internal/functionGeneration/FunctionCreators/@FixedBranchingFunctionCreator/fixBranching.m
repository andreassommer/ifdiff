function this = fixBranching(this, idxCtrlif)
%this = this.FIXBRANCHING(idxCtrlif)
%
%Replace ctrlif with its true or false part based on the signature.
%
%INPUT:
%   idxCtrlif - Index of the ctrlif in the signature (NOT the ctrlif_index).
%       positive integer
%
%OUTPUT:
%   this.exportMtreeArray - Mtree containing the ctrlif is updated.
%       1xN cell array of mtreeplus

ctrlifCallInfo = this.functionData.getCtrlifCallInfo( ...
    this.funcIter.idxMtreeCallerOriginal, ...
    this.signature.ctrlifIndex(idxCtrlif));

% True part stored in 2nd arg, false part in 3rd arg of ctrlif.
if this.signature.switchCond(idxCtrlif)
    idxArg = 2;
else
    idxArg = 3;
end

this.exportMtreeArray{this.funcIter.idxMtreeCallerExport} = replaceCtrlifByTrueOrFalse( ...
    this.exportMtreeArray{this.funcIter.idxMtreeCallerExport}, ...
    ctrlifCallInfo.rIndexEquals, ...
    ctrlifCallInfo.rIndexArgs(idxArg) ...
    );
end
