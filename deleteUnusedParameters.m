function mtreeobjNew = deleteUnusedParameters(mtreeobj)
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

% get string of the return value
cIndex_Outs = mtreeobj.T(rIndex.HEAD.Outs, cIndex.stringTableIndex);
output_variables = mtreeobj.C(cIndex_Outs);

% find the last statement that assigns any of the return values
output_variables_indices = mtreeobj.mtfind('String', output_variables).indices();
lastBodyNode = getFunctionBodyNode(mtreeobj, output_variables_indices(end));

% walk backwards through the mtree, starting from the node containing the return statement,
% deleting all nodes that do not (indirectly) contribute to setting the return value(s).
% output_variables contains all IDs that are somehow involved in defining the return value,
% so we know which nodes not to delete.
[mtreeobj, ~] = deleteUnusedParameters_walkBodyNodes(mtreeobj, output_variables, lastBodyNode);

mtreeobjNew = mtreeobj;

end %finito

function node = getFunctionBodyNode(mtreeobj, node)
% Given an mtree of a function and a node, find the body node (= top-level statement)
% that the node belongs to.
% This is useful e.g. when the return statement is within an if block. Then
% deleteUnusedParameters_walkBodyNodes needs the index of the if block, not of the
% return statement.
    cIndex = mtree_cIndex();
    rIndexHead = mtree_rIndex_head(mtreeobj);

    trueParent = mtreeobj.T(node, cIndex.trueParent);
    while trueParent ~= rIndexHead.FUNCTION
        node = mtreeobj.T(node, cIndex.indexParentNode);
        trueParent = mtreeobj.T(node, cIndex.trueParent);
    end
end


