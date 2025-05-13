function mtree = adjustHelperFunctionCall(mtree, newFunctionCallName, rIndexCall, rIndexArg3)
%mtree = ADJUSTHELPERFUNCTIONCALL(mtree, newFunctionCallName, rIndexCall, rIndexArg3)
%
%Modify mtree by changing name of a helper function call and removing unnecessary arguments.
%
%INPUT:
%   mtree - Mtree to be modified.
%       mtreeplus
%
%   newFunctionCallName - Name of the function that the function call should be replaced with.
%       char array
%
%   rIndexCall - rIndex of the function call in mtree.
%       positive integer
%
%   rIndexArg3 - rIndex of the third argument of the function call in mtree.
%   The first two arguments of a helper function call are the function index and datahandle which will be removed.
%       positive integer
%
%OUTPUT:
%   mtree - Modified mtree
%       mtreeplus

cIndex = mtree_cIndex();

% Change name of the function call
[mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
    rIndexCall, ...
    cIndex.indexLeftchild, ...
    {mtree.K.ID, newFunctionCallName});
% Remove the first two arguments (function index and datahandle)
mtree = mtree_connectNodes(...
    mtree, ...
    rIndexCall,...
    rIndexArg3,...
    cIndex.indexRightchild);
end
