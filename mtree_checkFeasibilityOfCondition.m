function cond_feasible = mtree_checkFeasibilityOfCondition(mtreeobj, index) 
% Function to check, whether a condition of a ctrlif is suitable to become
% a switching function. 
cIndex = mtree_cIndex; 
config = makeConfig(); 

mtreeobj_condition = Full(select(mtreeobj,index)); 

    
active_mtree = mtreeobj_condition.T(mtreeobj.IX, cIndex.kindOfNode);
if any(active_mtree == mtreeobj.K.EQ) || any(active_mtree == mtreeobj.K.NE)
    cond_feasible = false;
    return
end

for i = 1:length(config.forbiddenConditionStrings)
    if anystring(mtreeobj_condition, config.forbiddenConditionStrings{i})
        cond_feasible = false; 
        return 
    else 
        cond_feasible = true; 
    end 
end 


end 
