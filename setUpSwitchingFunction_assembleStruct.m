function switchingFcn = setUpSwitchingFunction_assembleStruct(datahandle, i)
% select and generate relavant information for assembling the
% switchingfunction and store them a struct switchingfunction


data = datahandle.getData();

switchingFcn.sI = data.SWP_detection.switchingIndices(i);
switchingFcn.i = i;


switchingFcn.mtreeobj = data.mtreeplus; 
switchingFcn.mtreeobj_switchingFcn = cell(7,1); 
% sI is the switching index, refered to the vectors in data.SWP_detection, get the ctrlif_index w.r.t. to sI
% switchingfunction.rhs_new_name = setUpSwitchingFunction_newName(switchingfunction, switchingfunction.sI, i);

% n-th switching functions refers to the n-th switch (n is suffix for switching function name)
switchingFcn.n = length(data.SWP_detection.switchingpoints) + 1;

switchingFcn.function_index_t1 = data.SWP_detection.function_index_t1;
switchingFcn.function_index_t1_temp = 0;

% every switching function gets a unique index and its functions index and
% ctrlifindex. 
data.SWP_detection.uniqueSwEnumeration = data.SWP_detection.uniqueSwEnumeration + 1; 
datahandle.setData(data); 
switchingFcn.uniqueSwEnumeration = data.SWP_detection.uniqueSwEnumeration;



switchingFcn.rhs_name_original = data.mtreeplus{2,1}; 

% get the function_index w.r.t. to sI
switchingFcn.function_index = data.SWP_detection.function_index_t1{switchingFcn.sI};
switchingFcn.ctrlif_index = data.SWP_detection.ctrlif_index_t1;
switchingFcn.condition = data.SWP_detection.switch_cond_t1;
switchingFcn.rhs_name = setUpSwitchingFunction_newName(switchingFcn, 0);
switchingFcn.mtreeobj_switchingFcn = {}; 

% starting value for nCurrentFunction (' = n' -> in next step consider
% function at mtreeobj_switchingFcn( ,n)). default value is 1 
switchingFcn.nCurrentFunction = 1;
switchingFcn.path = data.paths.preprocessed_switchingFunction;

end