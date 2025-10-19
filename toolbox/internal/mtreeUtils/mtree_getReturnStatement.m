function rIndexReturn = mtree_getReturnStatement(mtree)
%rIndexReturn = MTREE_GETRETURNSTATEMENT(mtree)
%
%Get row index of the last top-level statement modifying the output of a function.
%
%INPUT:
%   mtree - Mtree containing the function definition (as its main function, i.e. not local or nested).
%       mtreeplus
%
%OUTPUT:
%   rIndexReturn - Row index of the "return statement" in the mtree.
%       positive integer

rIndex = struct('HEAD', struct(), 'BODY', struct());
rIndex.HEAD = mtree_rIndex_head(mtree, rIndex.HEAD);

outputNames = mtree_getOutputNames(mtree, rIndex);
if ~isscalar(outputNames)
    throw(invalidNumberOfOutputs(outputNames));
end

rIndexOutputUsage = mtree.mtfind('String', outputNames).indices();
rIndexReturn = getFunctionBodyNode(mtree, rIndexOutputUsage(end), rIndex.HEAD);
end

%% Helpers
function node = getFunctionBodyNode(mtree, node, rIndexHead)
% Find body node (= top-level statement) of a node in an mtree.
% E.g. to find the index of an if-block for a return statement within an if-block.

cIndex = mtree_cIndex();

trueParent = mtree.T(node, cIndex.trueParent);
while trueParent ~= rIndexHead.FUNCTION
    node = mtree.T(node, cIndex.indexParentNode);
    trueParent = mtree.T(node, cIndex.trueParent);
end
end

%% Exceptions
function e = invalidNumberOfOutputs(outputNames)
msg = 'Unable to determine return statement: Number of function outputs should be 1, not %d.\n';
e = MException('IFDIFF:MtreeFindReturnStatement:InvalidNumberOfOutputs', msg, length(outputNames));
end
