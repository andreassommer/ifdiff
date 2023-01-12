function  [out, rIndex_node] = mtree_checkForComparisonOperator(mtreeobj, index)
% Function to check whether at the index and all following nodes exits any
% kind of comparison operator  "<", ">", "<=" or ">=". 
% INPUT: mtreeobj; 
% index: starting index of subtree that one wants to check for comparison
% operators

% set default values
out = 0; 
rIndex_node = []; 
if ischar(index) 
    return
end 

cIndex = mtree_cIndex();

child_active_set = mtree_getAllLeftRightChildren(mtreeobj, index); 

child_active_set_index = find(child_active_set == 1); 


kindOfNode_Condition = mtreeobj.T(child_active_set_index, cIndex.kindOfNode);

operators = [mtreeobj.K.GE, ...
    mtreeobj.K.GT, ...
    mtreeobj.K.LT, ...
    mtreeobj.K.LE];

ID(:,1) = (kindOfNode_Condition == operators(1)); 
ID(:,2) = (kindOfNode_Condition == operators(2)); 
ID(:,3) = (kindOfNode_Condition == operators(3)); 
ID(:,4) = (kindOfNode_Condition == operators(4)); 



% search for any 1
out_index = find(any(ID == 1, 1), 1); 

% if no comparsion operator: 0 as default. 
if ~isempty(out_index)
    out = operators(out_index); 
    
    out_index2 = find(any(ID == 1, 2), 2); 
    rIndex_node = child_active_set_index(out_index2); 
end 
  
    


end 
