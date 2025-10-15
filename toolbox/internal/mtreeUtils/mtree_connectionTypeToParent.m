function [parent_node_of_index, connection_type_to_parent_node] = mtree_connectionTypeToParent(mtreeobj, index)
% sometimes one does not know how (i.e. left, rightchild or nextindex) the parent node is connect to the node
% that one is currently considering. 
% This function determines the connectiontype and the parentnode index 
% 
% INPUT: 'index' -> it's parentnode is to be considered
% 
% OUTPUT: 'parent_node_of_index' -> parent node of index
% 'connection_type_to_parent_node' -> cIndex value of either leftchild, rightchild or nextNode
cIndex = mtree_cIndex();


% get connection type from the parent of expr_node
parent_node_of_index = mtreeobj.T(index, cIndex.indexParentNode);

connection_possiblities = [cIndex.indexLeftchild, cIndex.indexRightchild, cIndex.indexNextNode];
% check which element (left, right, next) matchs with the row index of the if
connection_type = find(mtreeobj.T(parent_node_of_index,connection_possiblities) == index, 1);

connection_type_to_parent_node = connection_possiblities(connection_type); 

end 