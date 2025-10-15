function mtreeobj = mtree_deleteBodyNode(mtreeobj, node)
    %MTREE_DELETEBODYNODE remove a body node from an mtree, connecting its predecessor and successor to each other

    cIndex = mtree_cIndex();

    % set the next node's parent to the previous
    nextNode = mtreeobj.T(node, cIndex.indexNextNode);
    parentNode = mtreeobj.T(node, cIndex.indexParentNode);
    if nextNode ~= 0
        mtreeobj.T(nextNode, cIndex.indexParentNode) = parentNode;
        % we do not need to set trueParent, as this is already the same for all body nodes
    end

    if parentNode ~= mtreeobj.T(node, cIndex.trueParent)
        % this means there is another body node before this one
        mtreeobj.T(parentNode, cIndex.indexNextNode) = nextNode;
    elseif mtreeobj.T(parentNode, cIndex.indexRightchild) == node
        % if, function, and other heads always have their body as a right child, so this branch covers that case
        mtreeobj.T(parentNode, cIndex.indexRightchild) = nextNode;
    else
        % I don't know if any kind of node has its body as a left child, but better be safe
        mtreeobj.T(parentNode, cIndex.indexLeftchild) = nextNode;
    end
end