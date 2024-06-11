function [switchingFcn, nextFunction] = ...
    setUpSwitchingFunction_setUpFcnCall(switchingFcn, currentFunction, function_index_index)
% In creating switching functions, a helper function may also need to be modified, in which case it
% gets exported under a new name. This function adapts calls of the helper function from other functions
% to the new name.
% Each function call's function_index is an array. function_index_index is the index into that array.
% currentFunction is which function (RHS or helper) we are modifying

cIndex = mtree_cIndex();

n = currentFunction;

% get name of the function call that is considered (w.r.t. function_index)
u = find(function_index_index == switchingFcn.mtreeobj_switchingFcn{4,n});

rIndex_fcn = switchingFcn.mtreeobj_switchingFcn{5,n};
cIndex_fcn = switchingFcn.mtreeobj_switchingFcn{3,n}.C;

% old_name of the function considered
oldName = cIndex_fcn{switchingFcn.mtreeobj_switchingFcn{3,n}.T(rIndex_fcn.Fname(u), cIndex.stringTableIndex)};
newName = setUpSwitchingFunction_newName(switchingFcn, function_index_index);

[switchingFcn, nextFunction] = ...
        setUpSwitchingFunction_findOrCreateSwitchingFcn(switchingFcn, newName, oldName);

[switchingFcn.mtreeobj_switchingFcn{3,n}, ~] = mtree_createAndAdd_NewNode(switchingFcn.mtreeobj_switchingFcn{3,n}, ...
    rIndex_fcn.Call(u), ...                     % from
    cIndex.indexLeftchild, ...                                       % from_types
    {switchingFcn.mtreeobj_switchingFcn{3,n}.K.ID, newName});

switchingFcn.mtreeobj_switchingFcn{3,n} = mtree_connectNodes(...
    switchingFcn.mtreeobj_switchingFcn{3,n}, ...
    rIndex_fcn.Call(u),...
    switchingFcn.mtreeobj_switchingFcn{5,n}.Arg(u,3),...
    cIndex.indexRightchild);
end 