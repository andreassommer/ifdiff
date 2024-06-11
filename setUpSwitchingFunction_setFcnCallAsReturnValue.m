function [switchingFcn, fcnCallIndex] = ...
    setUpSwitchingFunction_setFcnCallAsReturnValue(switchingFcn, nCurrentFunction, function_index_index)
% Modify the mtree specified by nCurrentFunction such that its return value is the value of the function call
% indicated by function_index_index.

config = makeConfig();
cIndex = mtree_cIndex();
n = nCurrentFunction;

rIndex = struct('HEAD', struct(), 'BODY', struct());
rIndex.HEAD = mtree_rIndex_head(switchingFcn.mtreeobj_switchingFcn{3,n}, rIndex.HEAD);
u = (function_index_index == switchingFcn.mtreeobj_switchingFcn{4,n});
rIndex_fcn = switchingFcn.mtreeobj_switchingFcn{5,n};

[switchingFcn.mtreeobj_switchingFcn{3,n}, ~] = mtree_createAndAdd_NewNode(switchingFcn.mtreeobj_switchingFcn{3,n}, ...
    rIndex_fcn.Equals(u), ...                 % from
    cIndex.indexLeftchild, ...                % from_type
    {switchingFcn.mtreeobj_switchingFcn{3,n}.K.ID, config.switchingfunction.name_outputvariable});

% new output for function in mtree_switchingFcn
[switchingFcn.mtreeobj_switchingFcn{3,n}, ~] = mtree_createAndAdd_NewNode(switchingFcn.mtreeobj_switchingFcn{3,n}, ...
    rIndex.HEAD.HEAD, ...             % from
    cIndex.indexLeftchild, ...        % from_type
    {switchingFcn.mtreeobj_switchingFcn{3,n}.K.ID,config.switchingfunction.name_outputvariable}); 

fcnCallIndex = u; 
end
