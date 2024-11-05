function [mtree, oldName, newName] = modifyFunctionCall(mtree, function_index, hash)
% In creating switching functions, a helper function may also need to be modified, in which case it
% gets exported under a new name. This function adapts calls of the helper function from other functions
% to the new name.
% Each function call's function_index is an array. function_index_index is the index into that array.
% currentFunction is which function (RHS or helper) we are modifying

cIndex = mtree_cIndex();
[mtree_functionIndex, mtree_rIndexFunctionIndex] = getFunctionIndex(mtree);


% First, determine to which function name the function_index belongs to
u = find(function_index == mtree_functionIndex);

% old_name of the function considered
oldName = mtree.C{mtree.T(mtree_rIndexFunctionIndex.Fname(u), cIndex.stringTableIndex)};

newName = createSwitchingFcnNewName(hash, oldName);

% Adjust the function call
[mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
    mtree_rIndexFunctionIndex.Call(u), ...                     % from
    cIndex.indexLeftchild, ...                                       % from_types
    {mtree.K.ID, newName});

mtree = mtree_connectNodes(...
    mtree, ...
    mtree_rIndexFunctionIndex.Call(u),...
    switchingFcn.mtreeobj_switchingFcn{5,n}.Arg(u,3),...
    cIndex.indexRightchild);
end 
