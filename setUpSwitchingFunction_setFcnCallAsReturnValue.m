function switchingFcn = setUpSwitchingFunction_setFcnCallAsReturnValue(switchingFcn, mtree_i, function_index_index)
% Modify the mtree specified by nCurrentFunction such that its return value is the value of the function call
% indicated by function_index_index.
    mtreeobj = switchingFcn.mtreeobj_switchingFcn{3,mtree_i};
    config = makeConfig();
    cIndex = mtree_cIndex();
    rIndex = struct('HEAD', struct(), 'BODY', struct());
    rIndex.HEAD = mtree_rIndex_head(mtreeobj, rIndex.HEAD);
    rIndex_fcn = switchingFcn.mtreeobj_switchingFcn{5,mtree_i};

    u = find(function_index_index == switchingFcn.mtreeobj_switchingFcn{4,mtree_i});

    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        rIndex_fcn.Equals(u), ...                 % from
        cIndex.indexLeftchild, ...                % from_type
        {mtreeobj.K.ID, config.switchingFunctionOutputName});

    % new output for function in mtree_switchingFcn
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        rIndex.HEAD.HEAD, ...             % from
        cIndex.indexLeftchild, ...        % from_type
        {mtreeobj.K.ID, config.switchingFunctionOutputName});

    % delete all code after the newly created return statement, and unnecessary if/elses
    returnStmtIndex = rIndex_fcn.Expr(u);
    mtreeobj.T(returnStmtIndex, mtree_cIndex().indexNextNode) = 0;
    mtreeobj = setUpSwitchingFunction_replaceIfElseByBody(mtreeobj, returnStmtIndex);
    sortedMtree = mtreeplus(mtreeobj.tree2str);
    mtreeobj = deleteUnusedParameters(sortedMtree);

    switchingFcn.mtreeobj_switchingFcn{3,mtree_i} = mtreeobj;
end
