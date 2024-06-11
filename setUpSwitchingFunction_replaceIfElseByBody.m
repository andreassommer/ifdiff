function mtreeobj = setUpSwitchingFunction_replaceIfElseByBody(mtreeobj, z, rIndex)
% given an mtree and a node index z, walk backward through the mtree starting from z. On encountering an if/else,
% delete the if/else and replace it with the body of the branch that contains z. That is, we are assuming that
% the if/elses will all branch in exactly such a way that z ends up getting executed, and condensing the
% function accordingly.
    cIndex = mtree_cIndex(); 
    
    while z ~= rIndex.HEAD.FUNCTION
        zNodeKind = mtreeobj.T(z, cIndex.kindOfNode);
        if ismember(zNodeKind, [mtreeobj.K.IFHEAD, mtreeobj.K.ELSE])
            % get the parent and the body of the if node
            if zNodeKind == mtreeobj.K.IFHEAD
                ifRoot   = mtreeobj.T(z, cIndex.indexParentNode);
            else
                ifRoot   = mtreeobj.T(mtreeobj.T(z, cIndex.indexParentNode), cIndex.indexParentNode);
            end
            ifRootParent = mtreeobj.T(ifRoot, cIndex.indexParentNode);
            bodyToKeep   = mtreeobj.T(z, cIndex.indexRightchild);
            
            childRelationType = [cIndex.indexLeftchild, ...
                cIndex.indexRightchild, ...
                cIndex.indexNextNode];
            idx = (mtreeobj.T(ifRootParent, childRelationType) == ifRoot);
    
            mtreeobj.T(ifRootParent, childRelationType(idx)) = bodyToKeep;
            mtreeobj.T(bodyToKeep, cIndex.indexParentNode) = ifRootParent;
            z = ifRootParent;
        else
            z = mtreeobj.T(z, cIndex.indexParentNode);
        end
    end
end