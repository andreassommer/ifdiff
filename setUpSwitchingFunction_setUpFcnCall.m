function switchingFcn = setUpSwitchingFunction_setUpFcnCall(switchingFcn, i, j) 
% consider function call with index j 
% get the correpesponding function, change its name and adapt 
% the function call, i.e. replace old name of fcn with new one. 
% create a new mtreeplus object with new function if not existing
% if it exist, use the existing 
% 
% i is row index of function_index 
% j is column index of the i-th function index 
% 
% relevant output: switchingFcn.n, index of the function that was called in
% function_index i,j; resp. the new created mtreeobj (either there is
% another function call or there is a ctrlif to consider) 

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

[switchingFcn, m] = setUpSwitchingFunction_checkForExistensOfSwitchingFunction(switchingFcn, switchingFcn.name_new, switchingFcn.name_old);
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