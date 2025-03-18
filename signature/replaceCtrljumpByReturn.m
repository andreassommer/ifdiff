function jumpFcn = replaceCtrljumpByReturn(mtree, ctrlif_index, ctrljumpArgs)
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
    cIndex   = mtree_cIndex;
    config   = makeConfig();
    jumpSpec   = config.jump.internalFunction;
    updateSpec = config.jump.updateFunction;
    rIndex = struct('HEAD', struct(), 'BODY', struct()); 
    rIndex.HEAD = mtree_rIndex_head(mtree, rIndex.HEAD); 

    % find the ctrljump whose ctrlif_index equals the one we are looking for
    ctrlif_indices = ctrljumpArgs(2, :);
    u              = find(ctrlif_indices == ctrlif_index);
    ctrljumpRIndex = ctrljumpArgs(1, u);

    [ifhead, rIndex_update] = replaceJumpifByCtrlif_parseJumpSpec(mtree, ctrljumpRIndex, jumpSpec);

    % new output variable for rhs
    [mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
        rIndex.HEAD.HEAD, ...                     % from
        cIndex.indexLeftchild, ...                % from_type
        {mtree.K.ID, config.jump.jumpFunctionOutputName});      % new variable

    updateCalls = rIndex_update.BODY.([updateSpec config.mtree_rIndex_function.Suffix_call]);
    updateArgs  = rIndex_update.BODY.([updateSpec '_Arg']);
    for i = 1:length(updateCalls)
        % create assignment statement that assigns the increment to the return value
        expr_rIndex = mtree.T(updateCalls(i), cIndex.indexParentNode);
        update_rIndex = updateArgs(i);
        [mtree, new_equal] = mtree_createAndAdd_NewNode(mtree, ...
            expr_rIndex, ...                        % from
            cIndex.indexLeftchild, ...           % from_type
            mtree.K.EQUALS);                  % kind of Node
        [mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
            new_equal, ...                             % from
            cIndex.indexLeftchild, ...                 % from_type
            {mtree.K.ID, config.jump.jumpFunctionOutputName});  % kind of Node; character string of new var
        mtree = mtree_connectNodes(mtree, ...
            new_equal, ...
            update_rIndex, ...
            cIndex.indexRightchild);
    end

    % replace the if block by only its body
    ifRoot   = mtree.T(ifhead, cIndex.indexParentNode);
    ifParent = mtree.T(ifRoot, cIndex.indexParentNode);
    ifNext   = mtree.T(ifRoot, cIndex.indexNextNode);
    updateBlockFirstNode = mtree.T(ifhead, cIndex.indexRightchild);
    updateBlockLastNode  = updateBlockFirstNode;
    while mtree.T(updateBlockLastNode, cIndex.indexNextNode) ~= 0
        updateBlockLastNode = mtree.T(updateBlockLastNode, cIndex.indexNextNode) ~= 0;
    end
    mtree = mtree_connectNodes(mtree, ...
        ifParent, ...
        updateBlockFirstNode, ...
        cIndex.indexNextNode);
    mtree = mtree_connectNodes(mtree, ...
        updateBlockLastNode, ...
        ifNext, ...
        cIndex.indexNextNode);

    mtree = setUpSwitchingFunction_traceReturnStatementToInputs(mtree, updateBlockLastNode);

    jumpFcn.mtreeobj_switchingFcn{3, mtree_i} = mtree;
end
