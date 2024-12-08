function mtreeobj = preprocess_setUpCtrlif_switchThenAndElsePart(mtreeobj, Arg1, Arg2, Arg3, Arg4) 
% Switches the order of the nodes Arg1, ..., Arg4, swapping Arg2 and Arg3. 
% For ctrlif, that means switching the arguments 'thenpart' and 'elsepart'. 
% This function assumes the local tree-structure to be:
%   Arg1 -next-> Arg2 -next-> Arg3 -next-> Arg4
%
% INPUT:
% 'mtreeobj     mtree
% 'Arg1'        Argument 1  (mtree index)
% 'Arg2'        Argument 2  (mtree index)
% 'Arg3'        Argument 3  (mtree index)
% 'Arg4'        Argument 4  (mtree index)
%
% OUTPUT:
% 'mtreeobj'    Edited mtree

% create struct for o.T column access
cIndex = mtree_cIndex(); 

idxCall = mtreeobj.T(Arg1, cIndex.indexParentNode);

% change the order of nodes to Arg1 -next-> Arg3 -next-> Arg2 -next-> Arg4
mtreeobj.T(Arg1, cIndex.indexNextNode) = Arg3;
mtreeobj.T(Arg3, cIndex.indexNextNode) = Arg2;
mtreeobj.T(Arg2, cIndex.indexNextNode) = Arg4;

% adjust parent fields
mtreeobj.T(Arg3, cIndex.indexParentNode) = mtreeobj.T(idxCall, cIndex.indexRightchild);
mtreeobj.T(Arg2, cIndex.indexParentNode) = Arg3;
mtreeobj.T(Arg4, cIndex.indexParentNode) = Arg2;

end