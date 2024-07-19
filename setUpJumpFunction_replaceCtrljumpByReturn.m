function jumpFcn = setUpJumpFunction_replaceCtrljumpByReturn(jumpFcn, mtree_i, ctrlif_i)
    config = makeConfig();
    cIndex = mtree_cIndex;
    mtreeobj = jumpFcn.mtreeobj_switchingFcn{3, mtree_i};
    rIndex = mtree_rIndex(mtreeobj);

    % find the ctrljump whose ctrlif_index equals the one we are looking for
    ctrlif_index   = jumpFcn.ctrlif_index_t1(ctrlif_i);
    args           = rIndex.BODY.([config.jump.internalFunction '_Arg']);
    ctrlif_indices = str2double(mtreeobj.C(mtreeobj.T(args(:,3), cIndex.stringTableIndex)))';
    u              = find(ctrlif_indices == ctrlif_index);

    ctrljump_expressions = rIndex.BODY.([config.jump.internalFunction '_expr']);
    expr_rIndex          = ctrljump_expressions(u);
    jumpIncrement_rIndex = args(u, 1);

    % new output variable for rhs
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        rIndex.HEAD.HEAD, ...                     % from
        cIndex.indexLeftchild, ...                % from_type
        {mtreeobj.K.ID, config.jump.jumpFunctionOutputName});      % new variable

    % create assignment statement that assigns the increment to the return value
    [mtreeobj, new_expr] = mtree_addNewExprNode(mtreeobj, expr_rIndex);
    [mtreeobj, new_equal] = mtree_createAndAdd_NewNode(mtreeobj, ...
        new_expr, ...                        % from
        cIndex.indexLeftchild, ...           % from_type
        mtreeobj.K.EQUALS);                  % kind of Node
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        new_equal, ...                                         % from
        cIndex.indexLeftchild, ...                             % from_type
        {mtreeobj.K.ID, config.jump.jumpFunctionOutputName});  % kind of Node; character string of new var
    mtreeobj = mtree_connectNodes(mtreeobj, ...
        new_equal, ...
        jumpIncrement_rIndex, ...
        cIndex.indexRightchild);

    % delete all code after the newly created return statement, and unnecessary if/elses
    returnStmtIndex = new_expr;
    mtreeobj.T(returnStmtIndex,cIndex.indexNextNode) = 0;
    mtreeobj = setUpSwitchingFunction_replaceIfElseByBody(mtreeobj, returnStmtIndex);
    sortedMtree = mtreeplus(mtreeobj.tree2str);
    mtreeobj = deleteUnusedParameters(sortedMtree);

    jumpFcn.mtreeobj_switchingFcn{3, mtree_i} = mtreeobj;
end