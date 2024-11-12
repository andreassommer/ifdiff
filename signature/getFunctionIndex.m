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

% Find all subtrees of updateFunctionIndex calls and get their row indices
rIndexUpdateFunctionIndex = mtree.mtfind('String', config.function_indexUpdateFunctionName).indices;

% There are no updateFunctionIndex calls
if isempty(rIndexUpdateFunctionIndex)
    fcn_index = [];
    fcn_index_rIndex = [];
    return
end

% Get the first and second argument of the updateFunctionIndex call
rIndexUpdateFunctionIndexCall = mtree.T(rIndexUpdateFunctionIndex, cIndex.indexParentNode)';
rIndexUpdateFunctionIndexArg1 = mtree.T(rIndexUpdateFunctionIndexCall, cIndex.indexRightchild)';
rIndexUpdateFunctionIndexArg2 = mtree.T(rIndexUpdateFunctionIndexArg1, cIndex.indexNextNode)';

% Get the expression node of the actual helper function call
rIndexUpdateFunctionIndexExpr = mtree_findNode(mtree, rIndexUpdateFunctionIndexCall, mtree.K.EXPR);
rIndexHelperFunctionExpr = mtree.T(rIndexUpdateFunctionIndexExpr, cIndex.indexNextNode)';
fcn_index_rIndex = mtree_rIndex_functionByExprNode(mtree, rIndexHelperFunctionExpr);


Arg2 = str2double(mtree.C(mtree.T(rIndexUpdateFunctionIndexArg2, cIndex.stringTableIndex)))';

% if second argument of setFunctionIndex is -1, then we are in rhs
if Arg2 == -1
    Arg1 = str2double(mtree.C(mtree.T(rIndexUpdateFunctionIndexArg1, cIndex.stringTableIndex)))';
    fcn_index = Arg1;
else
    % if not function_index is stored in second variable
    fcn_index = Arg2;
end
end
