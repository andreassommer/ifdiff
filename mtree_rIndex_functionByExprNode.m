function resu = mtree_rIndex_functionByExprNode(mtreeobj, i)
% function that gets all rIndex of a function call with an rIndex Node as
% input. All the other functions have the function name as input, here it
% is an rIndex.
% The fname rIndex, that is required for this function, can be retrieved
% from the varargout arguments of setIndex during the preprocessing.
% INPUT: 
% - mtreeobj
% - i: rIndex Node of Expr
cIndex = mtree_cIndex();

resu.Expr = i; 
resu.Equals = mtreeobj.T(resu.Expr, cIndex.indexLeftchild)';

resu.Call = mtreeobj.T(resu.Equals, cIndex.indexRightchild)';
resu.Fname = mtreeobj.T(resu.Call, cIndex.indexLeftchild)'; 

% get indices Arg 1, Arg 2, etc, when they exist
resu = mtree_rIndex_getFunctionArguments(mtreeobj, resu, 'Call');


end
































