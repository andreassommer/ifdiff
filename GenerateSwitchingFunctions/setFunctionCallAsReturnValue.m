function mtree = setFunctionCallAsReturnValue(mtree, outputName, rIndexEquals, rIndexExpr)
%mtree = SETFUNCTIONCALLASRETURNVALUE(mtree, outputName, rIndexEquals, rIndexExpr)
%
%Modify mtree by setting the output of the mtree function to the result of a function call contained in the mtree.
%Additionally, the mtree will be reparsed and everything irrelevant for the computation of the new output is removed.
%
%WARNING: This function will potentially invalidate existing row indices of the mtree!
%
%INPUT:
%   mtree - Mtree to be modified.
%       mtreeplus
%
%   outputName - Name for the new singular output variable of the function call and its caller function.
%       char array
%
%   rIndexEquals - rIndex of equals node of function call in mtree
%       positive integer
%
%   rIndexExpr - rIndex of the expression node of function call in mtree
%       positive integer
%
%OUTPUT:
%   mtree - Modified mtree with the function call assigned as the output of the caller function.
%   Additionally, all statements coming after the function call are deleted.
%   The mtree is then reparsed and all statements that do not contribute to the output of the caller function are removed.
%       mtreeplus

cIndex = mtree_cIndex();

rIndex = struct('HEAD', struct(), 'BODY', struct());
rIndex.HEAD = mtree_rIndex_head(mtree, rIndex.HEAD);

% Replace all previous outputs of the function with a singular new output.
[mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
    rIndexEquals, ...
    cIndex.indexLeftchild, ...
    {mtree.K.ID, outputName});

% Assign the result of the function call to the new output variable.
[mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
    rIndex.HEAD.HEAD, ...
    cIndex.indexLeftchild, ...
    {mtree.K.ID, outputName});

% Reparse the entire mtree and remove everything that is not required for the computation of the new output variable.
% WARNING: This will potentially invalidate existing row indices of the mtree!
mtree = traceReturnStatementToInputs(mtree, rIndexExpr);
end
