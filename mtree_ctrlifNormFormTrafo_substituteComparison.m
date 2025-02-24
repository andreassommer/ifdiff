function mtreeobj = mtree_ctrlifNormFormTrafo_substituteComparison(mtreeobj, idxRel)
% Changes type of node at idxRel to MINUS and adds parantheses before the right child of idxRel.
%
% Intended for converting 'a>=b' into 'a-(b)'
% (or any of <,>,<= instead of >=).
%
%
% INPUT:
% ´mtreeobj´        mtree
% ´idxRel´          index of relation
%
% OUTPUT:
% ´mtreeobj´        Edited mtree.


cIndex = mtree_cIndex();

% Replace comparison with MINUS
mtreeobj.T(idxRel, cIndex.kindOfNode) = mtreeobj.K.MINUS;

% Add parantheses around MINUS term
[mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
    idxRel, ...                     % from
    cIndex.indexRightchild, ...      % from_type
    mtreeobj.K.PARENS, ...           % new node
    mtreeobj.T(idxRel, cIndex.indexRightchild), ... % to
    cIndex.indexLeftchild); % to_type
end
