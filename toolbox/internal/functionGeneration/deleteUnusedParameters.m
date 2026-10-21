function mtreeobj = deleteUnusedParameters(mtreeobj)
% walk through an mtree object and delete all variables that are not
% relevant to generating the function's return value.
% 'mtreeobj': mtree object that should be simplified
% 'obj': simplified mtree object
%
% this function requires a topologically sorted mtree (i.e. which has not been
% manipulated before). If you do have a manipulated mtree, you can re-sort it by calling
% `mtreeobj = mtreeplus(mtreeobj.tree2str)`

cIndex = mtree_cIndex();
rIndex = struct('HEAD', struct(), 'BODY', struct());
rIndex.HEAD = mtree_rIndex_head(mtreeobj, rIndex.HEAD);

output_variables = mtree_getOutputNames(mtreeobj, rIndex);

% Nested functions share the workspace of the enclosing function, so they may read variables which are not passed
% as arguments. Since we walk backwards, assignments to such variables would be deleted before we reach the
% definition of the nested function. Thus, conservatively mark all IDs occurring in nested functions as relevant.
% Note: Local functions are not part of the subtree of the main function and therefore not affected.
mainFunctionTree = Tree(select(mtreeobj, rIndex.HEAD.FUNCTION));
nestedFunctions = mtree_mtfind(mainFunctionTree, 'Kind', mtreeobj.K.FUNCTION);
nestedFunctions = nestedFunctions(nestedFunctions ~= rIndex.HEAD.FUNCTION);
for i = 1:length(nestedFunctions)
    nestedFunctionTree = Tree(select(mtreeobj, nestedFunctions(i)));
    nestedIds = mtree_mtfind(nestedFunctionTree, 'Kind', mtreeobj.K.ID);
    output_variables = union(output_variables, mtreeobj.C(mtreeobj.T(nestedIds, cIndex.stringTableIndex)));
end

% Get the last body node (i.e. last top-level statement excluding nested function definitions)
rIndex.BODY = mtree_rIndex_lastNextNodeOfBody(mtreeobj, rIndex.BODY, rIndex.HEAD.BODY);

% Walk backwards through the mtree, starting from the last top-level statement in the function
% (which usually also corresponds to the last statement in the function modifying the outputs, i.e. the "return statement",
% since this function is mainly called in traceReturnStatementToInputs)
% deleting all nodes that do not (indirectly) contribute to setting the return value(s).
% output_variables contains all IDs that are somehow involved in defining the return value,
% so we know which nodes not to delete.
[mtreeobj, ~] = deleteUnusedParameters_walkBodyNodes(mtreeobj, output_variables, rIndex.BODY.lastNextNodeOfBody);
end
