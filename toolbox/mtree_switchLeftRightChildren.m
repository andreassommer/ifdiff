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

left = cIndex.indexLeftchild;
right = cIndex.indexRightchild;

mtreeobj.T(index, [left, right]) = mtreeobj.T(index, [right, left]);
end
