function switchingFcn = setUpSwitchingFunction_assembleStruct(datahandle, sI, namePrefix, folder)
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
switchingFcn.rhs_name = setUpSwitchingFunction_newName(switchingFcn, 0);

switchingFcn.path = folder;

end