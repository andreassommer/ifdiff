function [fcn_index, fcn_index_rIndex] = getFunctionIndex(mtree)
% How it works: 
% 1. Get all nodes corresponding to setFunctionIndex calls
% 2. Extract the arguments.
% 2a. If the second argument is a -1, then we are in the RHS and the function index is stored in the first argument
% 2b. Otherwise, we are in a helper function and the second argument holds the function_index
% 3. Get the expression node of the actual helper function call.
% 4. From there collect more useful nodes for the helper function, i.e. the EXPR, EQUALS, CALL, FNAME, and ARG (if any) nodes.
% Return: For all helper functions, their function index and rIndex of nodes relevant to the function call.

config = makeConfig();
cIndex = mtree_cIndex();

% Find all subtrees of setFunctionIndex calls and get their row indices
fname_subtree = mtree.mtfind('String', config.function_indexUpdateFunctionName);
fname = fname_subtree.indices;

% There are no setFunctionIndex calls
if isempty(fname)
    fcn_index = [];
    fcn_index_rIndex = [];
    return
end

% get Arg1 and Arg2
updateFunctionIndex_Call = mtree.T(fname, cIndex.indexParentNode)';
updateFunctionIndex_Arg1 = mtree.T(updateFunctionIndex_Call, cIndex.indexRightchild)';
updateFunctionIndex_Arg2 = mtree.T(updateFunctionIndex_Arg1, cIndex.indexNextNode)';

exprNodeOf_updateFunctionIndex_Call = mtree_findNode(mtree, updateFunctionIndex_Call, mtree.K.EXPR);
expr_node = mtree.T(exprNodeOf_updateFunctionIndex_Call, cIndex.indexNextNode)';
fcn_index_rIndex = mtree_rIndex_functionByExprNode(mtree, expr_node);


Arg2 = str2double(mtree.C(mtree.T(updateFunctionIndex_Arg2, cIndex.stringTableIndex)))';

% if second argument of setFunctionIndex is -1, then we are in rhs
if Arg2 == -1
    Arg1 = str2double(mtree.C(mtree.T(updateFunctionIndex_Arg1, cIndex.stringTableIndex)))';
    fcn_index = Arg1;
else
    % if not function_index is stored in second variable
    fcn_index = Arg2;
end
end
