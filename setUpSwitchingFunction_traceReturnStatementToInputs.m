function mtreeobj = setUpSwitchingFunction_traceReturnStatementToInputs(mtreeobj, returnStmtIndex)
%MTREE_TRACERETURNSTATEMENTTOINPUTS Trace a function's return statement to its inputs, deleting everything unnecessary
% returnStmtIndex is the row index of the return statement.
% Caveats:
% - the mtree is re-parsed, during which all existing rIndex values (including returnStmtIndex) become invalid
% - this function is used for building switching and jump functions. Since every ctrlif before the return statement
%   has been replaced by its truepart/falsepart, meaning all branching is fixed, we just blindly strip away all
%   if/else blocks. Do not use this function to simplify anything other than switching and jump functions.
    cIndex = mtree_cIndex();

    mtreeobj.T(returnStmtIndex,cIndex.indexNextNode) = 0;
    mtreeobj = setUpSwitchingFunction_replaceIfElseByBody(mtreeobj, returnStmtIndex);
    sortedMtree = mtreeplus(mtreeobj.tree2str);
    mtreeobj = deleteUnusedParameters(sortedMtree);
end