function switchingfunctionhandle = setUpSwitchingFunction(datahandle, i)
% set up and export to file the switching function corresponding to an index of an ctrlif call
%
% INPUT:
% 'mtreeobj': mtree object of the rhs function
% 'i': the index of the ctrlif call of the desired switching function
%
% OUTPUT: function handle of the corresponding switch
%
% 'switchingFunctionHandle': a function handle to the switching function that belongs to i


% select and generate relavant information for assembling the
% switchingfunction and store them a struct switchingfunction
switchingFcn = setUpSwitchingFunction_assembleStruct(datahandle, i);
switchingFcn = setUpSwitchingFunction_getFunctionIndices_wrapper(switchingFcn);
switchingFcn = setUpSwitchingFunction_getCtrlifIndices(switchingFcn);


% set up rhs, either the switch is in the rhs (then function_index = 0) or
% in a function that is in the rhs (or in a function and that function is
% in rhs .... etc., the functions may be nested)
% When switch is in rhs: remove all ctrlif, set new returnvalue, change
% name of variable and get the switching function from ctrlif with index
% ctrlif_index(sI) ; remove everthing after the specific ctlrif.


% change name if function (i.e. from preprocessed_rhs -> sw_preprocessed_rhs)
if isempty(switchingFcn.mtreeobj_switchingFcn)
    
    switchingFcn.mtreeobj_switchingFcn = switchingFcn.mtreeobj(:,1);
    
    switchingFcn.mtreeobj_switchingFcn{3,1} = mtree_changeFcnName(...
        switchingFcn.mtreeobj_switchingFcn{3,1}, switchingFcn.rhs_name);
    
    switchingFcn.mtreeobj_switchingFcn{1,1} = switchingFcn.rhs_name;
    
end


% mtree obj for switching fcn is ready, start removing ctrlif etc. 
% important are how functions that themself contain switches are handled. 
% approach: map over all function index that exist, handle them consecutively 
% 
% assume there are four elements in the ctrlifs/function_index. 
% and when we want the switching functions of the third element of the ctrlifs/function_index 
% Then sI = 3; l = 4. 
% Remove ctrlif element 1 and 2 and replace them with their corresponding truepart/falsepart
% Remove everything after ctrlif element 3 (i.e. 4 is removed) 
% Take ctrlif element 3 and form function index
l = length(switchingFcn.function_index_t1);
for i = 1:l
    % sI: SwitchingIndex; index w.r.t. to signature that caused the switch 
    if i == switchingFcn.sI
        switchingFcn = setUpSwitchingFunction_getSwitchingFcn(switchingFcn);
        break
    end

    % remove ctrlifs before sI and replace them with their corresponding truepart/falsepart
    for j = 1:length(switchingFcn.function_index_t1{i}) + 1
        switchingFcn = setUpSwitchingFunction_byFunctionIndex(switchingFcn, i, j);
    end
    
end



% export Switching Functions as source code
switchingfunctionhandle = setUpSwitchingFunction_ExportFunctions(switchingFcn);
end





















