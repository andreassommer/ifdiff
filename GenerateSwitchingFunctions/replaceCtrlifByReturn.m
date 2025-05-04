function mtree = replaceCtrlifByReturn(mtree, outputName, rIndexEquals, rIndexExpr, rIndexArgCond)
%mtree = REPLACECTRLIFBYRETURN(mtree, outputName, rIndexEquals, rIndexExpr, rIndexArgCond)
%
%Replace a ctrlif with a return statement containing its evaluated condition.
%
%WARNING: This function will potentially invalidate existing row indices of the mtree!
%
%INPUT:
%   mtree - Mtree containing the ctrlif to be replaced.
%       mtreeplus
%
%   outputName - Name for the new singular output variable of the ctrlif and its caller function.
%       char array
%
%   rIndexEquals - Row index of the EQUALS node assigning the output of the ctrlif.
%       positive integer
%
%   rIndexExpr - Row index of the EXPR node containing the ctrlif call.
%       positive integer
%
%   rIndexArgCond - Row index of the node containing the argument of the ctrlif call that holds the condition.
%   Note: The 1st argument of a ctrlif call contains the condition.
%       positive integer
%
%OUPUT:
%   mtree - Modified mtree with the ctrlif condition assigned as the output of the caller function.
%   Additionally, all statements coming after the ctrlif call are deleted.
%   The mtree is then reparsed and all statements that do not contribute to the output of the caller function are removed.
%       mtreeplus

cIndex = mtree_cIndex();

% Create new output variable for the ctrlif.
[mtree, ~] = mtree_createAndAdd_NewNode( ...
    mtree, ...
    rIndexEquals, ...
    cIndex.indexLeftchild, ...
    {mtree.K.ID, outputName} ...
    );

rIndex = struct('HEAD', struct(), 'BODY', struct());
rIndex.HEAD = mtree_rIndex_head(mtree, rIndex.HEAD);

% Set output variable of the RHS to the ctrlif output variable.
[mtree, ~] = mtree_createAndAdd_NewNode( ...
    mtree, ...
    rIndex.HEAD.HEAD, ...
    cIndex.indexLeftchild, ...
    {mtree.K.ID, outputName} ...
    );

% Extract switching function from condition argument of the ctrlif.
mtree = mtree_connectNodes(...
    mtree, ...
    rIndexEquals, ...
    rIndexArgCond, ...
    cIndex.indexRightchild ...
    );

mtree = traceReturnStatementToInputs(mtree, rIndexExpr);
end
