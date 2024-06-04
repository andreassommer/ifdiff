function switchingFcn = setUpSwitchingFunction_adaptOutputVariable(switchingFcn, function_index, j, n)
% when there is:
% y = preprocessed_fun(function_index, datahandle, y);
% replace it by
% returnvalue = preprocessed_fun(y);
%
% and change output variable in the function header to returnvalue

config = makeConfig(); 
cIndex = mtree_cIndex(); 

rIndex = struct('HEAD', struct(), 'BODY', struct());
rIndex.HEAD = mtree_rIndex_head(switchingFcn.mtreeobj_switchingFcn{3,n}, rIndex.HEAD);
function_index_i = switchingFcn.function_index_t1{function_index};
u = (function_index_i(j) == switchingFcn.mtreeobj_switchingFcn{4,n});
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



switchingFcn.u = u; 


end
