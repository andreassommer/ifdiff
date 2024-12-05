function [mtreeobj, ctrlif_index] = mtree_replaceJumpifByCtrlif(mtreeobj, ctrlif_index)
    config = makeConfig();
    rIndex = mtree_rIndex(mtreeobj);

    jumpSpec = config.jump.specifyingFunction;
    jumpFunc = config.jump.internalFunction;

    % check if there are any jumps specified in mtreeobj. if not, we are done
    if ~isfield(rIndex.BODY, jumpSpec)
        % nothing to do
        return
    end

    jumpSpecNodes = rIndex.BODY.(jumpSpec);
    argNodes     = rIndex.BODY.([jumpSpec '_Arg']);

    cIndex = mtree_cIndex();
    for i=1:length(jumpSpecNodes)
        jumpSpecNode = jumpSpecNodes(i);
        [ifhead, ~] = replaceJumpifByCtrlif_parseJumpSpec(mtreeobj, jumpSpecNode, jumpSpec);
        ifRoot = mtreeobj.T(ifhead, cIndex.indexParentNode);
        if config.jump.disable
            % if jump treatment is disabled, just remove the jump statement
            parent = mtreeobj.T(ifRoot, cIndex.indexParentNode);
            child = mtreeobj.T(ifRoot, cIndex.indexNextNode);
            if child == 0
                mtreeobj.T(parent, cIndex.indexNextNode) = 0;
            else
                mtreeobj = mtree_connectNodes(mtreeobj, parent, child, cIndex.indexNextNode);
            end
            continue;
        end
        argSwitchingFunction = argNodes(i, 1);
        argDirectionFlag     = argNodes(i, 2);

        % add a line conditionvalue = ctrlif(...)
        [mtreeobj, ctrlifExpr]   = mtree_addNewExprNode(mtreeobj, ifRoot);
        [mtreeobj, ctrlifEquals] = mtree_createAndAdd_NewNode(mtreeobj, ...
            ctrlifExpr, ...                        % from
            cIndex.indexLeftchild, ...           % from_type
            mtreeobj.K.EQUALS);                  % kind of Node
        [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj,...
            ctrlifEquals, ...                                    % from
            cIndex.indexLeftchild, ...                           % from_type
            {mtreeobj.K.ID, config.ctrlif.outputName});          % kind of new node
        [mtreeobj,    ~] = preprocess_setUpCtrlif(mtreeobj,...
            ctrlifEquals, ...
            ctrlif_index, ...
            argSwitchingFunction, ...
            'true', ...
            'false');

        % replace the jump specifier with the internal function
        % if ifdiff_jumpif(switchingFunction, direction) -> if ctrljump(direction, ctrlif_index)
        [mtreeobj, jumpCall] = mtree_createAndAdd_NewNode(mtreeobj, ...
            ifhead, ...
            cIndex.indexLeftchild, ...
            mtreeobj.K.CALL);
        [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
            jumpCall, ...
            cIndex.indexLeftchild, ...
            {mtreeobj.K.ID, jumpFunc});
        [mtreeobj, argCtrlifIndex] = mtree_createAndAdd_NewNode(mtreeobj, ...
            jumpCall, ...
            cIndex.indexRightchild, ...
            {mtreeobj.K.INT, sprintf('%d', ctrlif_index)});
        mtreeobj = mtree_connectNodes(mtreeobj, argCtrlifIndex, argDirectionFlag, cIndex.indexNextNode);

        % and don't forget to update ctrlif index
        ctrlif_index = ctrlif_index + 1;
    end
end