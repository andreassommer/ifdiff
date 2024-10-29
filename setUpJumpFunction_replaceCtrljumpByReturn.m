function jumpFcn = setUpJumpFunction_replaceCtrljumpByReturn(datahandle, jumpFcn, mtree_i, ctrlif_i)
% SETUPJUMPFUNCTION_REPLACECTRLJUMPBYRETURN Replace the ctrlif and ctrljump that signal a jump with the body of the
%     jump's update block, creating a function that returns the update.
% A jump specification
%
% ctrlif(<switchingFunction> >= 0, ..., <ctrlif_index>, ...)
% if ctrljump(<ctrlif_index>, <direction>)
%     ... statements ...
%     ifdiff_update(<update>);
% end
%
% is replaced by
% 
% ... statements ...
% jump_increment = <update>
%
% and the function's return variable changed to jump_increment.
    data     = datahandle.getData();
    cIndex   = mtree_cIndex;
    config   = makeConfig();
    jumpSpec   = config.jump.internalFunction;
    updateSpec = config.jump.updateFunction;
    mtreeobj = jumpFcn.mtreeobj_switchingFcn{3, mtree_i};
    rIndex = struct('HEAD', struct(), 'BODY', struct()); 
    rIndex.HEAD = mtree_rIndex_head(mtreeobj, rIndex.HEAD); 

    % find the ctrljump whose ctrlif_index equals the one we are looking for
    ctrlif_index   = jumpFcn.ctrlif_index_t1(ctrlif_i);
    ctrljumpArgs   = data.SWP_detection.jumpConditions;
    ctrlif_indices = ctrljumpArgs(2, :);
    u              = find(ctrlif_indices == ctrlif_index);
    ctrljumpRIndex = ctrljumpArgs(1, u);

    [ifhead, rIndex_update] = replaceJumpifByCtrlif_parseJumpSpec(mtreeobj, ctrljumpRIndex, jumpSpec);

    % new output variable for rhs
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        rIndex.HEAD.HEAD, ...                     % from
        cIndex.indexLeftchild, ...                % from_type
        {mtreeobj.K.ID, jumpFcn.outputVariable});      % new variable

    updateCalls = rIndex_update.BODY.([updateSpec config.mtree_rIndex_function.Suffix_call]);
    updateArgs  = rIndex_update.BODY.([updateSpec '_Arg']);
    for i = 1:length(updateCalls)
        % create assignment statement that assigns the increment to the return value
        expr_rIndex = mtreeobj.T(updateCalls(i), cIndex.indexParentNode);
        update_rIndex = updateArgs(i);
        [mtreeobj, new_equal] = mtree_createAndAdd_NewNode(mtreeobj, ...
            expr_rIndex, ...                        % from
            cIndex.indexLeftchild, ...           % from_type
            mtreeobj.K.EQUALS);                  % kind of Node
        [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
            new_equal, ...                             % from
            cIndex.indexLeftchild, ...                 % from_type
            {mtreeobj.K.ID, jumpFcn.outputVariable});  % kind of Node; character string of new var
        mtreeobj = mtree_connectNodes(mtreeobj, ...
            new_equal, ...
            update_rIndex, ...
            cIndex.indexRightchild);
    end

    % replace the if block by only its body
    ifRoot   = mtreeobj.T(ifhead, cIndex.indexParentNode);
    ifParent = mtreeobj.T(ifRoot, cIndex.indexParentNode);
    ifNext   = mtreeobj.T(ifRoot, cIndex.indexNextNode);
    updateBlockFirstNode = mtreeobj.T(ifhead, cIndex.indexRightchild);
    updateBlockLastNode  = updateBlockFirstNode;
    while mtreeobj.T(updateBlockLastNode, cIndex.indexNextNode) ~= 0
        updateBlockLastNode = mtreeobj.T(updateBlockLastNode, cIndex.indexNextNode) ~= 0;
    end
    mtreeobj = mtree_connectNodes(mtreeobj, ...
        ifParent, ...
        updateBlockFirstNode, ...
        cIndex.indexNextNode);
    mtreeobj = mtree_connectNodes(mtreeobj, ...
        updateBlockLastNode, ...
        ifNext, ...
        cIndex.indexNextNode);

    mtreeobj = setUpSwitchingFunction_traceReturnStatementToInputs(mtreeobj, updateBlockLastNode);

    jumpFcn.mtreeobj_switchingFcn{3, mtree_i} = mtreeobj;
end