function mtreeobj = mtree_connectNodes(mtreeobj, from,to,by)
% Connect two nodes in an mtree.
% INPUT:
%   mtreeobj: the mtree
%   from: intended parent node
%   to: intended child node
%   by: connection type, one of cIndex.indexRightChild, cIndex.indexLeftChild, cIndex.indexNextNode.

cIndex = mtree_cIndex();


mtreeobj.T(from, by) = to; 
mtreeobj.T(to, cIndex.indexParentNode) = from;
if by ~= cIndex.indexNextNode
    % body-type nodes are connected to a linked list with the indexNextNode prop. The trueParent property of all
    % body nodes points to the head of the list (e.g. the head of a function or the "if" node in an if block)
    mtreeobj.T(to, cIndex.trueParent) = from;
end

end
