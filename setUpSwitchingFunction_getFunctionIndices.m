function [out, out_rIndex] = setUpSwitchingFunction_getFunctionIndices(mtreeobj) 
% when the function index is set, (in the ctrlif) 
% find out in which order which function (with its corresponding index)
% occurs in the function
config = makeConfig();
cIndex = mtree_cIndex(); 
fname_subtree = mtreeobj.mtfind('String', config.function_indexUpdateFunctionName);
fname = fname_subtree.indices; 

if isempty(fname) 
    out = []; 
    out_rIndex = [];  
    return
end 

% get Arg1 and Arg2 
updateFunctionIndex_Call = mtreeobj.T(fname, cIndex.indexParentNode)'; 
updateFunctionIndex_Arg1 = mtreeobj.T(updateFunctionIndex_Call, cIndex.indexRightchild)'; 
updateFunctionIndex_Arg2 = mtreeobj.T(updateFunctionIndex_Arg1, cIndex.indexNextNode)'; 

exprNodeOf_updateFunctionIndex_Call = mtree_findNode(mtreeobj, updateFunctionIndex_Call, mtreeobj.K.EXPR); 
expr_node = mtreeobj.T(exprNodeOf_updateFunctionIndex_Call, cIndex.indexNextNode)'; 
out_rIndex = mtree_rIndex_functionByExprNode(mtreeobj, expr_node);

% if second argument of setFunctionIndex is -1, then we are in rhs

% get second argument - if it is -1, that means we are in the RHS. -1 can be either expressed as UMINUS(INT 1)
% or just as INT -1. Both cases are covered here.
if mtreeobj.T(updateFunctionIndex_Arg2, cIndex.kindOfNode) == mtreeobj.K.UMINUS
    rhsTrue = 1;
else
    Arg2 = str2double(mtreeobj.C(mtreeobj.T(updateFunctionIndex_Arg2, cIndex.stringTableIndex)))';
    rhsTrue = (Arg2 == -1); 
end
if rhsTrue 
    Arg1 = str2double(mtreeobj.C(mtreeobj.T(updateFunctionIndex_Arg1, cIndex.stringTableIndex)))'; 
    out = Arg1; 
else
    % if not function_index is stored in second variable
    out = Arg2; 
end 

 


end 
