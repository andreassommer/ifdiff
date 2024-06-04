function switchingFcn = setUpSwitchingFunction_replaceCtrlifByReturn(switchingFcn, mtree_i)
% replace a ctrlif with a return statement that returns the LHS of its condition. Example:
% Replace
% function dx = preprocessed_myRhs(t, x, p, datahandle)
%     cond = ctrlif(t*x >= 0, true, false, ...)
%     if cond
%         <ifbody>
%     end
% end
%
% with
% function switch_val = preprocessed_myRhs(t, x, p, datahandle)
%     switch_val = t*x;
% end
% mtree_i is the index into switchingFcn.mtreeobj_switchingFcn, i.e. which function's mtree we want to modify.
% (the ctrlif could be in the RHS or any helper function)
    config = makeConfig();
    cIndex = mtree_cIndex;

    n = mtree_i;
    % find out which ctrlif (e.g. first, second...) is the considered
    % ctrlif w.r.t to the function
    u = find(switchingFcn.ctrlif_index(switchingFcn.sI) == switchingFcn.mtreeobj_switchingFcn{6,n});

    rIndex_ctrlif = switchingFcn.mtreeobj_switchingFcn{7,n};
    % replace ctrlif by its thenpart/elsepart (resp. to the condition)

    ctrlif_cond = switchingFcn.mtreeobj_switchingFcn{3,n}.T(rIndex_ctrlif.ctrlif_Arg(u,1), cIndex.indexLeftchild);

    % new output variable for ctrlif
    [switchingFcn.mtreeobj_switchingFcn{3,n}, ~] = mtree_createAndAdd_NewNode(switchingFcn.mtreeobj_switchingFcn{3,n}, ...
        rIndex_ctrlif.ctrlif_Equals(u), ...              % from
        cIndex.indexLeftchild, ...                       % from_type
        {switchingFcn.mtreeobj_switchingFcn{3,n}.K.ID, config.switchingfunction.name_outputvariable});
    
    rIndex = struct('HEAD', struct(), 'BODY', struct());
    rIndex.HEAD = mtree_rIndex_head(switchingFcn.mtreeobj_switchingFcn{3,n}, rIndex.HEAD);

    % new output variable for rhs
    [switchingFcn.mtreeobj_switchingFcn{3,n}, ~] = mtree_createAndAdd_NewNode(switchingFcn.mtreeobj_switchingFcn{3,n}, ...
        rIndex.HEAD.HEAD, ...                     % from
        cIndex.indexLeftchild, ...                % from_type
        {switchingFcn.mtreeobj_switchingFcn{3,n}.K.ID, config.switchingfunction.name_outputvariable});      % new variable

    % receive switching function from condition of ctrlif
    switchingFcn.mtreeobj_switchingFcn{3,n} = mtree_connectNodes(...
        switchingFcn.mtreeobj_switchingFcn{3,n}, ...
        rIndex_ctrlif.ctrlif_Equals(u), ...
        ctrlif_cond, ...
        cIndex.indexRightchild);

    % delete everything after the ctrlif
    switchingFcn.mtreeobj_switchingFcn{3,n}.T(rIndex_ctrlif.ctrlif_expr(u),cIndex.indexNextNode) = 0;

    switchingFcn.mtreeobj_switchingFcn{3,n} = setUpSwitchingFunction_handleIfCondition(...
        switchingFcn.mtreeobj_switchingFcn{3,n}, rIndex_ctrlif.ctrlif_expr(u), rIndex);
end