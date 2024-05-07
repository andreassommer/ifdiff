function index = mtree_rIndex_lastNextNodeOfBody(mtreeobj, index, body)
cIndex = mtree_cIndex(); 

% Part 2: LastNextNodeofBody
% Find the last body node of the function that is not a nested function declaration.

% first, get the last node without checking for nested functions
veryLastNextNode = mtree_lastNextNodeIndex(mtreeobj, body);

% this veryLastNextNode may be a nested function. So go backwards until we find a non-function node.
last = veryLastNextNode;
while (mtreeobj.T(last, cIndex.indexParentNode) ~= mtreeobj.T(last, cIndex.trueParent)) && ...
        strcmp(mtreeobj.KK{mtreeobj.T(last, cIndex.kindOfNode)}, 'FUNCTION')
    last = mtreeobj.T(last, cIndex.indexParentNode);
end
index.lastNextNodeOfBody = last;

end 
