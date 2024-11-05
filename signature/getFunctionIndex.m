function [fcn_index, fcn_index_rIndex] = getFunctionIndex(mtree)
% when the function index is set, (in the ctrlif)
% find out in which order which function (with its corresponding index)
% occurs in the function
config = makeConfig();
cIndex = mtree_cIndex();


fname_subtree = mtree.mtfind('String', config.function_indexUpdateFunctionName);
fname = fname_subtree.indices;

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
