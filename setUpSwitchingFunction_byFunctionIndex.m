function switchingFcn = setUpSwitchingFunction_byFunctionIndex(switchingFcn, i)
% replace a ctrlif inside a helper function with its truepart/ falsepart.
% i is the index into the ctrlif_index, function_index, and switch_cond arrays

    cIndex = mtree_cIndex();
    n = switchingFcn.nCurrentFunction;

    % find out which ctrlif (e.g. first, second...) is the considered
    % ctrlif w.r.t to the function
    u = find(switchingFcn.ctrlif_index(i) == switchingFcn.mtreeobj_switchingFcn{6,n});

    rIndex_ctrlif = switchingFcn.mtreeobj_switchingFcn{7,n};
    % replace ctrlif by its thenpart/elsepart (resp. to the condition)

    if switchingFcn.condition(i)
        switchingFcn.mtreeobj_switchingFcn{3,n} = mtree_connectNodes(...
            switchingFcn.mtreeobj_switchingFcn{3,n}, ...
            rIndex_ctrlif.ctrlif_Equals(u), ...
            rIndex_ctrlif.ctrlif_Arg(u,2), ...
            cIndex.indexRightchild);
    else
        switchingFcn.mtreeobj_switchingFcn{3,n} = mtree_connectNodes(...
            switchingFcn.mtreeobj_switchingFcn{3,n}, ...
            rIndex_ctrlif.ctrlif_Equals(u), ...
            rIndex_ctrlif.ctrlif_Arg(u,3), ...
            cIndex.indexRightchild);
    end

    % reset to default
    switchingFcn.nCurrentFunction = 1; 
end