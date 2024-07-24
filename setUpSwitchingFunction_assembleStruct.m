function switchingFcn = setUpSwitchingFunction_assembleStruct(datahandle, sI, namePrefix, outputVariable, folder)
% create a struct for building the switching function and set a few properties in it, as well as
% incrementing the uniqueSwEnumeration property of data.SWP_detection
data = datahandle.getData();

switchingFcn.sI = sI;

switchingFcn.mtreeobj = data.mtreeplus;

switchingFcn.function_index_t1 = data.SWP_detection.function_index_t1;
switchingFcn.ctrlif_index_t1   = data.SWP_detection.ctrlif_index_t1;
switchingFcn.switch_cond_t1    = data.SWP_detection.switch_cond_t1;

switchingFcn.uniqueSwEnumeration = data.SWP_detection.uniqueSwEnumeration;

switchingFcn.rhs_name_original = data.mtreeplus{2,1}; 
switchingFcn.namePrefix = namePrefix;
switchingFcn.outputVariable = outputVariable;
switchingFcn.rhs_name = setUpSwitchingFunction_newName(switchingFcn, 0);

switchingFcn.path = folder;

% Assign the function and ctrlif indices to the functions in which they appear
switchingFcn = setUpSwitchingFunction_getFunctionIndices_wrapper(switchingFcn);
switchingFcn = setUpSwitchingFunction_getCtrlifIndices(switchingFcn);

% make a copy of the mtree for modifying, change name of the RHS (e.g. from preprocessed_rhs -> sw_preprocessed_rhs)
% helper functions will be copied and renamed later only if they are actually needed
switchingFcn.mtreeobj_switchingFcn = switchingFcn.mtreeobj(:,1);
switchingFcn.mtreeobj_switchingFcn{3,1} = mtree_changeFcnName(switchingFcn.mtreeobj_switchingFcn{3,1}, switchingFcn.rhs_name);
switchingFcn.mtreeobj_switchingFcn{1,1} = switchingFcn.rhs_name;

end