function mtreeobj = setUpSwitchingFunction_handleIfCondition(mtreeobj, z, rIndex)
% check if we are inside a if/else statement (for/while/switch not yet
% supported), and walk through the function to delete everything what
% is not needed anymore
% 
% INPUT: mtreeobj, z: starting node 
% OUTPUT: mtreeobj 
cIndex = mtree_cIndex(); 


while z ~= rIndex.HEAD.FUNCTION
    % check for if or else statement
    if mtreeobj.T(z, cIndex.kindOfNode) == mtreeobj.K.IFHEAD
        % get the parent and the body of the if node
        ifnode          = mtreeobj.T(z, cIndex.indexParentNode);
        parent_of_if_node = mtreeobj.T(ifnode, cIndex.indexParentNode);
        bodyofifnode    = mtreeobj.T(z, cIndex.indexRightchild);
        
        type = [cIndex.indexLeftchild, ...
            cIndex.indexRightchild, ...
            cIndex.indexNextNode];
        idx = (mtreeobj.T(parent_of_if_node, type) == ifnode);
        
        mtreeobj.T(parent_of_if_node, type(idx)) = bodyofifnode;
        mtreeobj.T(bodyofifnode, cIndex.indexParentNode) = parent_of_if_node;
        
        % adjust z
        z = parent_of_if_node;
    elseif mtreeobj.T(z, cIndex.kindOfNode) == mtreeobj.K.ELSE
        % get the parent of and the corresponding if node and the body of the else node
        if_node = mtreeobj.T(mtreeobj.T(z, cIndex.indexParentNode), cIndex.indexParentNode);
        parent_of_if_node = mtreeobj.T(if_node, cIndex.indexParentNode);
        else_node_body = mtreeobj.T(z, cIndex.indexRightchild);
        
        type = [cIndex.indexLeftchild, ...
            cIndex.indexRightchild, ...
            cIndex.indexNextNode];
        idx = (mtreeobj.T(parent_of_if_node, type) == if_node);
        
        mtreeobj.T(parent_of_if_node, type(idx)) = else_node_body;
        mtreeobj.T(else_node_body, cIndex.indexParentNode) = parent_of_if_node;
        
        % adjust z
        z = parent_of_if_node;
    else
        % only adjust z
        z = mtreeobj.T(z, cIndex.indexParentNode);
    end
end

end