function obj = normFormExecCtrlif_addSubtractionCtrlif(mtreeobj, idxRel, paren)
% converting 'a>=b' into 'a-b>=0'
% 'o': mtreeobject 
% 'idxRel': index of relation
% 'paren': optional parameter, if paren == 1 a node for parenthesis
% have to be added
if (nargin == 2)
    prths = 0;
else
    prths = paren;
end

% create struct for o.T column access
cIndex = mtree_cIndex(); 

if prths
   % lngthT + 1; NewNode01
    [mtreeobj, minus_node] = mtree_createAndAdd_NewNode(mtreeobj, ...
        idxRel, ...                     % from
        cIndex.indexLeftchild, ...      % from_type
        mtreeobj.K.MINUS, ...           % new node
        mtreeobj.T(idxRel, cIndex.indexLeftchild), ... % to
        cIndex.indexLeftchild); % to_type
    
    % lngthT + 3; NewNode03
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        minus_node, ...                     % from
        cIndex.indexRightchild, ...      % from_type
        mtreeobj.K.PARENS, ...           % new node
        mtreeobj.T(idxRel, cIndex.indexRightchild), ... % to
        cIndex.indexLeftchild); % to_type
    
    % lngthT + 2; NewNode02
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        idxRel, ...                     % from
        cIndex.indexRightchild, ....    % from_type
        {mtreeobj.K.INT, '0'});         % new integer
    
else
    
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        idxRel, ...                     % from
        cIndex.indexLeftchild, ...      % from_type
        mtreeobj.K.MINUS, ...           % new node
        [mtreeobj.T(idxRel, cIndex.indexLeftchild), mtreeobj.T(idxRel, cIndex.indexRightchild)], ... % to
        [cIndex.indexLeftchild, cIndex.indexRightchild]); % to_type
    
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        idxRel, ...                     % from
        cIndex.indexRightchild, ....    % from_type
        {mtreeobj.K.INT, '0'});         % new integer

end

obj = mtreeobj; 
end