function switchingFcn = setUpSwitchingFunction_setUpFcnCall(switchingFcn, i, j)
% In creating switching functions, a helper function may also need to be modified, in which case it
% gets exported under a new name. This function adapts calls of the helper function from other functions
% to the new name.

cIndex = mtree_cIndex();

n = switchingFcn.nCurrentFunction;

% find function call w.r.t to the function index
function_index_i = switchingFcn.function_index_t1{i};
function_index_j = function_index_i(j);

% get name of the function call that is considered (w.r.t. function_index)
u = find(function_index_j == switchingFcn.mtreeobj_switchingFcn{4,n});

rIndex_fcn = switchingFcn.mtreeobj_switchingFcn{5,n};
cIndex_fcn = switchingFcn.mtreeobj_switchingFcn{3,n}.C;

% old_name of the function considered
switchingFcn.name_old = cIndex_fcn{switchingFcn.mtreeobj_switchingFcn{3,n}.T(rIndex_fcn.Fname(u), cIndex.stringTableIndex)};

switchingFcn.name_new = setUpSwitchingFunction_newName(switchingFcn, function_index_j);

[switchingFcn, m] = setUpSwitchingFunction_findOrCreateSwitchingFcn(switchingFcn, switchingFcn.name_new, switchingFcn.name_old);
switchingFcn.nCurrentFunction = m;

[switchingFcn.mtreeobj_switchingFcn{3,n}, ~] = mtree_createAndAdd_NewNode(switchingFcn.mtreeobj_switchingFcn{3,n}, ...
    switchingFcn.mtreeobj_switchingFcn{5,n}.Call(u), ...                     % from
    cIndex.indexLeftchild, ...                                       % from_types
    {switchingFcn.mtreeobj_switchingFcn{3,n}.K.ID, switchingFcn.name_new});

switchingFcn.mtreeobj_switchingFcn{3,n} = mtree_connectNodes(...
    switchingFcn.mtreeobj_switchingFcn{3,n}, ...
    switchingFcn.mtreeobj_switchingFcn{5,n}.Call(u),...
    switchingFcn.mtreeobj_switchingFcn{5,n}.Arg(u,3),...
    cIndex.indexRightchild);
end 