function switchingFcn = setUpSwitchingFunction_assembleStruct(datahandle, i)
% create a struct for building the switching function and set a few properties in it
data = datahandle.getData();

switchingFcn.sI = data.SWP_detection.switchingIndices(i);

switchingFcn.mtreeobj = data.mtreeplus; 
switchingFcn.mtreeobj_switchingFcn = cell(7,1); 

switchingFcn.function_index_t1 = data.SWP_detection.function_index_t1;

% every switching function gets a unique index and its functions index and
% ctrlifindex. 
data.SWP_detection.uniqueSwEnumeration = data.SWP_detection.uniqueSwEnumeration + 1; 
datahandle.setData(data); 
switchingFcn.uniqueSwEnumeration = data.SWP_detection.uniqueSwEnumeration;

switchingFcn.rhs_name_original = data.mtreeplus{2,1}; 

% get the function_index w.r.t. to sI
switchingFcn.ctrlif_index = data.SWP_detection.ctrlif_index_t1;
switchingFcn.condition = data.SWP_detection.switch_cond_t1;
switchingFcn.rhs_name = setUpSwitchingFunction_newName(switchingFcn, 0);
switchingFcn.mtreeobj_switchingFcn = {}; 

switchingFcn.path = data.paths.preprocessed_switchingFunction;

end