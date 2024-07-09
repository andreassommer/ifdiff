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

    fcnCallNodes = rIndex.BODY.([jumpSpec '_call']);
    argNodes     = rIndex.BODY.([jumpSpec '_Arg']);

    cIndex = mtree_cIndex();
    for i=1:length(rIndex.BODY.(jumpSpec))
        lineStart = mtree_findBeginOfLine(mtreeobj, fcnCallNodes(i), mtreeobj.K.EXPR);
        argSwitchingFunction = argNodes(i, 1);
        argDirectionFlag     = argNodes(i, 2);
        argJumpIncrement     = argNodes(i, 3);
        % add a line conditionvalue = ctrlif(...)
        [mtreeobj, ctrlifExpr]   = mtree_addNewExprNode(mtreeobj, lineStart);
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
        jumpCall = mtreeobj.T(lineStart, cIndex.indexLeftchild);
        [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
            jumpCall, ...
            cIndex.indexLeftchild, ...
            {mtreeobj.K.ID, jumpFunc});
        mtreeobj = mtree_connectNodes(mtreeobj, jumpCall, argJumpIncrement, cIndex.indexRightchild);
        mtreeobj = mtree_connectNodes(mtreeobj, argJumpIncrement, argDirectionFlag, cIndex.indexNextNode);
        [mtreeobj, ctrlifIndexArg] = mtree_createAndAdd_NewNode(mtreeobj, ...
            argDirectionFlag, ...
            cIndex.indexNextNode, ...
            {mtreeobj.K.INT, sprintf('%d', ctrlif_index)});
        [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
            ctrlifIndexArg, ...
            cIndex.indexNextNode, ...
            {mtreeobj.K.ID, config.ctrlif.outputName});

        % and don't forget to update ctrlif index
        ctrlif_index = ctrlif_index + 1;
    end
end