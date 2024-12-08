function mtreeobj = mtree_ctrlifNormFormTrafo_substituteComparison(mtreeobj, idxRel, paren)
% Changes type of node at idxRel to MINUS and adds parantheses before the
% right child of idxRel if paren==1.
% 
% Intended for converting 'a>=b' into 'a-b' 
% (or any of <,>,<= instead of >=).
%
%
% INPUT:
% ´mtreeobj´        mtree
% ´idxRel´          index of relation
% ´paren´           optional parameter;
%                   if paren == 1 a node for parenthesis is added.
%
% OUTPUT:
% ´mtreeobj´        Edited mtree.


% if paren==1, add parantheses
if (nargin == 2)
    prths = 0;
else
    prths = paren;
end

% helper struct for mtreeobj.T column accesses
cIndex = mtree_cIndex(); 


% exchange comparison to MINUS
mtreeobj.T(idxRel, cIndex.kindOfNode) = mtreeobj.K.MINUS;

if prths    
    % add parentheses
    % lngthT + 1; NewNode01
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        idxRel, ...                     % from
        cIndex.indexRightchild, ...      % from_type
        mtreeobj.K.PARENS, ...           % new node
        mtreeobj.T(idxRel, cIndex.indexRightchild), ... % to
        cIndex.indexLeftchild); % to_type
end

end