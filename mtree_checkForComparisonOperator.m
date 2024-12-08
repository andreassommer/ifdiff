function  [kind, rIndex] = mtree_checkForComparisonOperator(mtreeobj, index)
% Searches the subtree of ´mtreeobj´ defined by ´index´ for nodes that are
% represent the following comparison operators: "<", ">", "<=" or ">=". 
%
% INPUT: 
% ´mtreeobj´        mtree
% ´index´           Node index that defines the subtree to be searched.
%
%
% OUTPUT:
% ´kind´            Kind of operators that appear.
% ´rIndex´          Their respective indices in the mtree.

% If nothing is found, return 0 and an empty array
kind = 0; 
rIndex = []; 

if ischar(index) 
    return
end 

cIndex = mtree_cIndex();
child_active_set = mtree_getAllLeftRightChildren(mtreeobj, index); 
child_active_set_index = find(child_active_set == 1); 

kindOfNode = mtreeobj.T(child_active_set_index, cIndex.kindOfNode);

operators = [mtreeobj.K.GE, ...
    mtreeobj.K.GT, ...
    mtreeobj.K.LT, ...
    mtreeobj.K.LE];

ID(:,1) = (kindOfNode == operators(1)); 
ID(:,2) = (kindOfNode == operators(2)); 
ID(:,3) = (kindOfNode == operators(3)); 
ID(:,4) = (kindOfNode == operators(4)); 

% Compute indices of operators that appear
operators_index = find(any(ID == 1, 1), 1); 

if ~isempty(operators_index)
    kind = operators(operators_index);
    
    % Also return the indices of the nodes where they appear
    out_index2 = find(any(ID == 1, 2), 2);
    rIndex = child_active_set_index(out_index2);
end 
  
end 