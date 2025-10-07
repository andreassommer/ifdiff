function [mtreeobj, new_expr_node_index] = mtree_addNewExprNode(mtreeobj, expr_node_index)
% add new expr node before 'expr_node'
% INPUT: 'expr_node': expr node in the mtree
% OUTPUT: 'mtreeobj' with new expr node
%         'new_expr_node_index: index of new node

cIndex = mtree_cIndex();


[parent_node_of_expr_node, connection_type] = mtree_connectionTypeToParent(mtreeobj, expr_node_index); 

% add new node expr and connect to expr_node_index by indexNextNode
[mtreeobj, new_expr_node_index] = mtree_createAndAdd_NewNode(mtreeobj,...
    parent_node_of_expr_node, ...                               % from
    connection_type, ...    % from_type
    mtreeobj.K.EXPR, ...                                 % kind of new node
    expr_node_index, ...                                 % to
    cIndex.indexNextNode);                               % to_type
end