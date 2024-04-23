function mtreeobj = mtree_getAllLeftRightChildren_recursion(mtreeobj, childs)
% recursive function to get all right and left childs of an index (and the
% right and left child of the childs of index....and so on) 
% active set of mtreeobj has to be set to zero for every value
% 
% 
% childs: index to consider (since it is recursive the input is
% dynamically, i.e. index ~ index of child ~ child)
% 
% OUTPUT: mtreeobj with an active set;
% i-th component of mtreeobj.IX = 0 ~ no child of child of child of ....
% i-th component of mtreeobj.IX = 1 ~ i-th line in mtreeobj.T is somehow connected to input index 
% 
% subset mtreeobj.T by mtreeobj.IX to get relevant lines 
cIndex = mtree_cIndex();
connection_possiblities = [cIndex.indexLeftchild, cIndex.indexRightchild];

for i = 1:length(childs) 
    z = childs(i); 
    childs_new =  mtreeobj.T(z, connection_possiblities);

    if ~any(childs_new(:))
        % stop function when node has no childs at all
        return
    end 
    % set active set for childs
    set = childs_new(childs_new ~= 0); 
    mtreeobj.IX(set) = 1; 
    
    % call the same function again
    mtreeobj = mtree_getAllLeftRightChildren_recursion(mtreeobj, childs_new); 
end 
 
end 


