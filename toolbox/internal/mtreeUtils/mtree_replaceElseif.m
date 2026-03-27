function mtree = mtree_replaceElseif(mtree)
%mtree = MTREE_REPLACEELSEIF(mtree)
%
%Replace all elseif blocks with semantically equivalent else-if blocks.
%
%INPUT:
%   mtree - Mtree containing the elseif blocks.
%       mtreeplus
%
%OUTPUT:
%   mtree - Modified mtree with all elseif blocks replaced by else-if blocks.
%       mtreeplus

% Get all ELSEIF nodes.
nodeElseifFull = mtree.mtfind('Kind', 'ELSEIF');
if nodeElseifFull.m == 0
    % No elseif in code.
    return
end

cIndex = mtree_cIndex;
% Handle each ELSEIF node separately, since multiple can be attached to one if.
for idxElseif=nodeElseifFull.indices
    nodeElseif = nodeElseifFull.select(idxElseif);
    % Get IFHEAD node of ELSEIF node.
    nodeIfhead = nodeElseif.Parent;

    % Add ELSE node to IFHEAD via Next.
    [mtree, nodeElseIdx] = mtree_createAndAdd_NewNode( ...
        mtree, ...
        nodeIfhead.indices, cIndex.indexNextNode, ...
        mtree.K.ELSE);

    % Add IF node as Body of ELSE node (right child). Connect IF node to ELSEIF node via Arg (left child).
    mtree = mtree_createAndAdd_NewNode( ...
        mtree, ...
        nodeElseIdx, cIndex.indexRightchild, ...
        mtree.K.IF, ...
        nodeElseif.indices, cIndex.indexLeftchild);

    % Change ELSEIF node to IFHEAD node. (same structure so only change node type)
    mtree.T(nodeElseif.indices, cIndex.kindOfNode) = mtree.K.IFHEAD;
end
end
