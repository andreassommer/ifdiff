function switchingFcn = setUpSwitchingFunction_noSwitch(switchingFcn, i, j)

cIndex = mtree_cIndex; 
n = switchingFcn.nCurrentFunction; 

switchingFcn = setUpSwitchingFunction_setUpFcnCall(switchingFcn, i, j);
[switchingFcn, fcnCallIndex] = setUpSwitchingFunction_adaptOutputVariable(switchingFcn, i, j, n);

% delete everything after the function call with switch
switchingFcn.mtreeobj_switchingFcn{3,n}.T(switchingFcn.mtreeobj_switchingFcn{5,n}.Expr(fcnCallIndex), cIndex.indexNextNode) = 0;
end