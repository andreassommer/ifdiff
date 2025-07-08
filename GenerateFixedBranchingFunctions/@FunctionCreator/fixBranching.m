function this = fixBranching(this, idxCtrlif)
% For jump functions: All ctrlifs are replaced by their true or false part.
% For switching functions: All ctrlifs except for the last are replaced by their true or false part.
% True part is stored in the second argument of the ctrlif, false part in the third.

ctrlifCallInfo = this.functionData.getCtrlifCallInfo(this.funcIter.idxMtreeCallerOriginal, this.signature.ctrlifIndex(idxCtrlif));

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
