function obj = normFormExecCtrlif_switchChildrenCtrlif(mtreeobj, idx)
% switching children of mtree object node (no 'string work')
%
%
% 'o' is mtree object
% 'idx' index of node of which the children nodes should be changed
% 'obj' is a mtree object with changed nodes

cIndex = mtree_cIndex(); 

% save indices of left and right child
lfIdx = mtreeobj.T(idx, cIndex.indexLeftchild);
rtIdx = mtreeobj.T(idx, cIndex.indexRightchild);

% swapping children
mtreeobj.T(idx, cIndex.indexLeftchild) = rtIdx;
mtreeobj.T(idx, cIndex.indexRightchild) = lfIdx;

% returning new changed mtree object
obj = mtreeobj;
end