function lastNextNodeIndex = mtree_lastNextNodeIndex(mtreeobj, firstNextNodeIndex)
    %LASTNEXTNODEINDEX Get the last "next" node in the body of a function, if/else, or other body.
    % caution: you must pass the first "next" node as firstNextNodeIndex, not the head of the body! This
    % is because we cannot be sure whether the body is the left or right child of the head. You have to
    % figure this out before calling this function.
    cIndex = mtree_cIndex();

    lastNextNodeIndex = firstNextNodeIndex;
    while mtreeobj.T(lastNextNodeIndex, cIndex.indexNextNode) ~= 0
        lastNextNodeIndex = mtreeobj.T(lastNextNodeIndex, cIndex.indexNextNode);
    end
end