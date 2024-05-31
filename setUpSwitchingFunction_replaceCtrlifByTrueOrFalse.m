function switchingFcn = setUpSwitchingFunction_replaceCtrlifByTrueOrFalse(switchingFcn, ctrlif_i, mtree_i)
% replace a ctrlif inside a helper function with its truepart/ falsepart.
% ctrlif_i is the index into the ctrlif_index, function_index, and switch_cond arrays.
% mtree_i is the index into switchingFcn.mtreeobj_switchingFcn, i.e. which function's mtree we want to modify.

    cIndex = mtree_cIndex();

    % find out which ctrlif (e.g. first, second...) is the considered
    % ctrlif w.r.t to the function
    u = find(switchingFcn.ctrlif_index(ctrlif_i) == switchingFcn.mtreeobj_switchingFcn{6,mtree_i});

    rIndex_ctrlif = switchingFcn.mtreeobj_switchingFcn{7,mtree_i};

    if switchingFcn.condition(ctrlif_i)
        switchingFcn.mtreeobj_switchingFcn{3,mtree_i} = mtree_connectNodes(...
            switchingFcn.mtreeobj_switchingFcn{3,mtree_i}, ...
            rIndex_ctrlif.ctrlif_Equals(u), ...
            rIndex_ctrlif.ctrlif_Arg(u,2), ...
            cIndex.indexRightchild);
    else
        switchingFcn.mtreeobj_switchingFcn{3,mtree_i} = mtree_connectNodes(...
            switchingFcn.mtreeobj_switchingFcn{3,mtree_i}, ...
            rIndex_ctrlif.ctrlif_Equals(u), ...
            rIndex_ctrlif.ctrlif_Arg(u,3), ...
            cIndex.indexRightchild);
    end
end