function switchingFcn = setUpSwitchingFunction_getFunctionIndices_wrapper(switchingFcn)
% for loop over getfunctionIndices 
% 
l = size(switchingFcn.mtreeobj, 2);
for i = 1:l
    [fcn_index, fcn_index_rIndex] = setUpSwitchingFunction_getFunctionIndices(switchingFcn.mtreeobj{3,i});
    switchingFcn.mtreeobj{4,i} = fcn_index;
    switchingFcn.mtreeobj{5,i} = fcn_index_rIndex;
end

end

