function rIndexReturn = mtree_getReturnStatement(mtree)
rIndex = struct('HEAD', struct(), 'BODY', struct()); 
rIndex.HEAD = mtree_rIndex_head(mtree, rIndex.HEAD);

outputNames = mtree_getOutputNames(mtree, rIndex);
rIndexOutputUsage = mtree.mtfind('String', outputNames).indices();
rIndexReturn = getFunctionBodyNode(mtree, rIndexOutputUsage(end));
end

function node = getFunctionBodyNode(mtree, node)
% Given an mtree of a function and a node, find the body node (= top-level statement)
% that the node belongs to.
% This is useful e.g. when the return statement is within an if block. Then
% deleteUnusedParameters_walkBodyNodes needs the index of the if block, not of the
% return statement.
cIndex = mtree_cIndex();
rIndexHead = mtree_rIndex_head(mtree);

trueParent = mtree.T(node, cIndex.trueParent);
while trueParent ~= rIndexHead.FUNCTION
    node = mtree.T(node, cIndex.indexParentNode);
    trueParent = mtree.T(node, cIndex.trueParent);
end
end
