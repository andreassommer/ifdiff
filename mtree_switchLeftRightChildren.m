function mtreeobj = mtree_switchLeftRightChildren(mtreeobj, index)
% mtreeobj = mtree_switchLeftRightChildren(mtreeobj, index)
%
% In ´mtreeobj´, switches the left and right children of the node at ´index´.
%
% INPUT:
% 'mtreeobj'    mtree
% 'index        Index of node of which the left/right children should be 
%               swapped (mtree index).
%
% OUTPUT:
% 'mtreeobj'    Edited mtree.

cIndex = mtree_cIndex(); 

% save indices of left and right child
leftIndex   = mtreeobj.T(index, cIndex.indexLeftchild);
rightIndex  = mtreeobj.T(index, cIndex.indexRightchild);

% swapping children
mtreeobj.T(index, cIndex.indexLeftchild)    = rightIndex;
mtreeobj.T(index, cIndex.indexRightchild)   = leftIndex;

end