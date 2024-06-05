function [switchingFcn, nextFunction] = setUpSwitchingFunction_noSwitch(switchingFcn, nCurrentFunction, function_index_index)

cIndex = mtree_cIndex; 
n = nCurrentFunction;

[switchingFcn, nextFunction] = setUpSwitchingFunction_setUpFcnCall(switchingFcn, n, function_index_index);
[switchingFcn, fcnCallIndex] = setUpSwitchingFunction_adaptOutputVariable(switchingFcn, n, function_index_index);

% delete everything after the function call with switch
switchingFcn.mtreeobj_switchingFcn{3,n}.T(switchingFcn.mtreeobj_switchingFcn{5,n}.Expr(fcnCallIndex), cIndex.indexNextNode) = 0;
end