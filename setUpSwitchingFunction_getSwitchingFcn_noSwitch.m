function switchingFcn = setUpSwitchingFunction_getSwitchingFcn_noSwitch(switchingFcn, i, j)

cIndex = mtree_cIndex; 


n = switchingFcn.nCurrentFunction; 

% get name of function call that is to consider, i.e. the call with
% function_index_sI(i), change its name and create new mtreeobj in
% mtree_swichtingFcn
switchingFcn = setUpSwitchingFunction_setUpFcnCall(switchingFcn, i, j);

switchingFcn = setUpSwitchingFunction_getSwitchingFcn_adaptOutputVariable(switchingFcn, i, j, n);

% delete everything after the function call with switch
switchingFcn.mtreeobj_switchingFcn{3,n}.T(switchingFcn.mtreeobj_switchingFcn{5,n}.Expr(switchingFcn.u), cIndex.indexNextNode) = 0;



end