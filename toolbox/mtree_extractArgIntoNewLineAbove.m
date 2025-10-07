function [mtreeobj, new_index] = mtree_extractArgIntoNewLineAbove(mtreeobj, index, unique_char_string)
% extract anything that follows after index into a new line 
% 
% INPUT: index: index of argument that one wants in new line
% unique_char_string: new name of temp variable 
% 
% OUTPUT: new_index: index of the new variable within the old function call
% 
% example: 
% 
% index: Arg 1 of max
% unique_char_string: new_Arg1
% 
% a = max(abs(k*x), c);
% 
% is changed to 
% 
% new_Arg1 = abs(k*x); 
% a = max(new_Arg1, c);
% 
% 
% new_index here: index to new_Arg 1 in line of max call (i.e. new Arg 1 of max, replacement to index)

cIndex = mtree_cIndex();


beginn_of_line = mtree_findBeginOfLine(mtreeobj, index, mtreeobj.K.EXPR);

[mtreeobj, beginn_of_line] = mtree_addNewExprNode(mtreeobj, beginn_of_line);

[mtreeobj, new_equal] = mtree_createAndAdd_NewNode(mtreeobj, ...
    beginn_of_line, ...                  % from
    cIndex.indexLeftchild, ...           % from_type
    mtreeobj.K.EQUALS);                  % kind of Node; character string of new var


[mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
    new_equal, ...                       % from
    cIndex.indexLeftchild, ...           % from_type
    {mtreeobj.K.ID, unique_char_string});                  % kind of Node; character string of new var

[old_parent_of_call, connection_type] = mtree_connectionTypeToParent(mtreeobj, index);
mtreeobj = mtree_connectNodes(mtreeobj, new_equal, index, cIndex.indexRightchild);


[mtreeobj, new_index] = mtree_createAndAdd_NewNode(mtreeobj, ...
    old_parent_of_call, ...                       % from
    connection_type, ...           % from_type
    {mtreeobj.K.ID, unique_char_string});



% check if index has any nextNode and retain the old connection if exists
old_next_node_of_index = mtreeobj.T(index, cIndex.indexNextNode);
if old_next_node_of_index ~= 0
    mtreeobj = mtree_connectNodes(mtreeobj, new_index, old_next_node_of_index, cIndex.indexNextNode);
end





end
