function  [kind, rIndex] = mtree_getFirstComparisonOperator(mtreeobj, index)
% Searches the subtree of ´mtreeobj´ defined by ´index´ for the first node which
% represents one of the following comparison operators: "<", ">", "<=" or ">=".
%
% INPUT:
% ´mtreeobj´        mtree
% ´index´           Node index that defines the subtree to be searched.
%
%
% OUTPUT:
% ´kind´            Kind of operator that was found.
% ´rIndex´          Node index of the operator that was found in the mtree.

% If nothing is found, return 0 and an empty array
kind = 0;
rIndex = [];


cIndex = mtree_cIndex();
rIndexNode = find(mtree_getAllLeftRightChildren(mtreeobj, index));
kindOfNode = mtreeobj.T(rIndexNode, cIndex.kindOfNode);

operators = [
    mtreeobj.K.GE, ...
    mtreeobj.K.GT, ...
    mtreeobj.K.LT, ...
    mtreeobj.K.LE];

% For each child node (column): check if type matches one of the comparison operators
nodeOperators = transpose(kindOfNode == operators);

% Find first child node which contains a comparison operator
[idxOperator, idxNode] = find(nodeOperators, 1);
if ~isempty(idxOperator)
    kind = operators(idxOperator);
    rIndex = rIndexNode(idxNode);
end
end
