function switchingFcn = setUpSwitchingFunction_replaceCtrlifByReturn(switchingFcn, mtree_i, ctrlif_i)
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
% ctrlif_i is the index into the ctrlif_index, function_index, and switch_cond arrays.
    mtreeobj = switchingFcn.mtreeobj_switchingFcn{3,mtree_i};
    cIndex = mtree_cIndex;
    rIndex = struct('HEAD', struct(), 'BODY', struct());
    rIndex.HEAD = mtree_rIndex_head(mtreeobj, rIndex.HEAD);
    rIndex_ctrlif = switchingFcn.mtreeobj_switchingFcn{7,mtree_i};

    % map the global ctrlif index to the ctrlif_index (1st, 2nd, ...) within this function only
    u = find(switchingFcn.ctrlif_index_t1(ctrlif_i) == switchingFcn.mtreeobj_switchingFcn{6,mtree_i});

    % rename the function's output variable to better reflect its purpose
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        rIndex.HEAD.HEAD, ...                          % from
        cIndex.indexLeftchild, ...                     % from_type
        {mtreeobj.K.ID, switchingFcn.outputVariable}); % new variable

    % return the expression the ctrlif is monitoring for zero crossings
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        rIndex_ctrlif.ctrlif_Equals(u), ...              % from
        cIndex.indexLeftchild, ...                       % from_type
        {mtreeobj.K.ID, switchingFcn.outputVariable});
    ctrlif_cond = mtreeobj.T(rIndex_ctrlif.ctrlif_Arg(u,1), cIndex.indexLeftchild);
    mtreeobj = mtree_connectNodes(...
        mtreeobj, ...
        rIndex_ctrlif.ctrlif_Equals(u), ...
        ctrlif_cond, ...
        cIndex.indexRightchild);

    mtreeobj = setUpSwitchingFunction_traceReturnStatementToInputs(mtreeobj, rIndex_ctrlif.ctrlif_expr(u));

    switchingFcn.mtreeobj_switchingFcn{3,mtree_i} = mtreeobj;
end