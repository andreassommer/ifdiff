function obj = normFormExecCtrlif_switchThenAndElsePart(mtreeobj, Arg1, Arg2, Arg3, Arg4) 
% switching children of mtreeobj object node 
%
% 'o': is mtree object
% 'idx': index of IIf call node
% 'obj': is a mtree object with changed nodes

% create struct for o.T column access
cIndex = mtree_cIndex(); 

idxCall = mtreeobj.T(Arg1, cIndex.indexParentNode);

% change the order of nodes
mtreeobj.T(Arg1, cIndex.indexNextNode) = Arg3;
mtreeobj.T(Arg3, cIndex.indexNextNode) = Arg2;
mtreeobj.T(Arg2, cIndex.indexNextNode) = Arg4;
% adjust parent nodes
mtreeobj.T(Arg3,cIndex.indexParentNode) = mtreeobj.T(idxCall, cIndex.indexRightchild);
mtreeobj.T(Arg2, cIndex.indexParentNode) = Arg3;



obj = mtreeobj;
end