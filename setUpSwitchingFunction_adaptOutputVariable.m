function [switchingFcn, fcnCallIndex] = setUpSwitchingFunction_adaptOutputVariable(switchingFcn, nCurrentFunction, function_index_index)
% when there is:
% y = preprocessed_fun(function_index, datahandle, y);
% replace it by
% returnvalue = preprocessed_fun(y);
% and change output variable in the function header to returnvalue
% Each function call's function_index is an array. function_index_index is the index into that array.

config = makeConfig();
cIndex = mtree_cIndex();
n = nCurrentFunction;

rIndex = struct('HEAD', struct(), 'BODY', struct());
rIndex.HEAD = mtree_rIndex_head(switchingFcn.mtreeobj_switchingFcn{3,n}, rIndex.HEAD);
u = (function_index_index == switchingFcn.mtreeobj_switchingFcn{4,n});
rIndex_fcn = switchingFcn.mtreeobj_switchingFcn{5,n};

% change the name of the function call that contains the switch
[switchingFcn.mtreeobj_switchingFcn{3,n}, ~] = mtree_createAndAdd_NewNode(switchingFcn.mtreeobj_switchingFcn{3,n}, ...
    rIndex_fcn.Call(u), ...             % from
    cIndex.indexLeftchild, ...                % from_type
    {switchingFcn.mtreeobj_switchingFcn{3,n}.K.ID, switchingFcn.name_new});

[switchingFcn.mtreeobj_switchingFcn{3,n}, ~] = mtree_createAndAdd_NewNode(switchingFcn.mtreeobj_switchingFcn{3,n}, ...
    rIndex_fcn.Equals(u), ...                               % from
    cIndex.indexLeftchild, ...                % from_type
    {switchingFcn.mtreeobj_switchingFcn{3,n}.K.ID, config.switchingfunction.name_outputvariable});

% new Output for function in mtree_switchingFcn
[switchingFcn.mtreeobj_switchingFcn{3,n}, ~] = mtree_createAndAdd_NewNode(switchingFcn.mtreeobj_switchingFcn{3,n}, ...
    rIndex.HEAD.HEAD, ...             % from
    cIndex.indexLeftchild, ...                % from_type
    {switchingFcn.mtreeobj_switchingFcn{3,n}.K.ID,config.switchingfunction.name_outputvariable}); 

fcnCallIndex = u; 
end
