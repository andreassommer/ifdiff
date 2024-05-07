function obj = deleteUnusedParameters(mtreeobj)
% walk through an mtree object and delete all variables that are not
% used in generating the function's return value.
% 'mtreeobj': mtree object that should be simplified
% 'obj': simplified mtree object
% 
% this function requires a topologically sorted mtree (i.e. which has not been
% manipulated before). If you do have a manipulated mtree, you can fix it with
% `mtreeobj = mtreeplus(mtreeobj.tree2str)`

% create struct for o.T column access
cIndex = mtree_cIndex(); 
rIndex = struct('HEAD', struct(), 'BODY', struct()); 
rIndex.HEAD = mtree_rIndex_head(mtreeobj, rIndex.HEAD);

% get string of the return value
cIndex_Outs = mtreeobj.T(rIndex.HEAD.Outs, cIndex.stringTableIndex);
output_variables = mtreeobj.C{cIndex_Outs};

% find all ID nodes of the return values
index_list_output_variables_mtree = mtreeobj.mtfind('String', output_variables); 
index_list_output_variables = index_list_output_variables_mtree.indices; 

% taking the last appearence of the output variables und starting from there
returnValueIndex = index_list_output_variables(end);
lastBodyNode = getFunctionBodyNode(mtreeobj, returnValueIndex);

% creating an array of all IDs that are relevant to computing the return value
idStringArray = mtreeobj.C(mtreeobj.T(returnValueIndex, cIndex.stringTableIndex));

% perform a backwards breadth-first search from the return value node, deleting all syntax tree nodes that do not
% (indirectly) contribute to setting the return value. idStringArray contains all IDs that
% are somehow involved in defining the return value, so we can find out which nodes not to delete.
[mtreeobj, ~] = deleteUnusedParameters_walkBodyNodes(mtreeobj, idStringArray, lastBodyNode);

% output
obj = mtreeobj;

end %finito

function node = getFunctionBodyNode(mtreeobj, node)
% The body of a function (or if, or for loop, or similar, for that matter) is a linked list of nodes. Each node links
% to its parent through the indexParentNode (9) entry in mtreeobj.T. We can find the original parent of the list
% with the trueParent (13) entry.
    cIndex = mtree_cIndex();
    rIndexHead = mtree_rIndex_head(mtreeobj);

    trueParent = mtreeobj.T(node, cIndex.trueParent);
    while trueParent ~= rIndexHead.FUNCTION
        node = mtreeobj.T(node, cIndex.indexParentNode);
        trueParent = mtreeobj.T(node, cIndex.trueParent);
    end
end


