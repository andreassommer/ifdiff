function child_active_set = mtree_getAllLeftRightChildren(mtreeobj, index)
% wrapper for the recursive function that searchs for all childs (left &
% right) of a node. For details look there
cIndex = mtree_cIndex(); 


mtreeobj.IX = zeros(1, length(mtreeobj.IX)); 
mtreeobj.n = 0; 
mtreeobj.T(index,cIndex.indexNextNode) = 0; 

% start searching for all right and left childs until all the nodes have no
% childs at all
mtreeobj = mtree_getAllLeftRightChildren_recursion(mtreeobj, index);
mtreeobj.IX(index) = 1; 
child_active_set = mtreeobj.IX; 



end 


