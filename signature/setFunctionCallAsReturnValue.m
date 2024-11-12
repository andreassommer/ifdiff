function mtree = setFunctionCallAsReturnValue(mtree, function_index)

config = makeConfig();
cIndex = mtree_cIndex();

[mtree_functionIndex, mtree_rIndexFunctionIndex] = getFunctionIndex(mtree);

rIndex = struct('HEAD', struct(), 'BODY', struct());
rIndex.HEAD = mtree_rIndex_head(mtree, rIndex.HEAD);

functionCallIndex = (function_index == mtree_functionIndex);

[mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
    mtree_rIndexFunctionIndex.Equals(functionCallIndex), ...                 % from
    cIndex.indexLeftchild, ...                % from_type
    {mtree.K.ID, config.switchingFunctionOutputName});

% new output for function in mtree_switchingFcn
[mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
    rIndex.HEAD.HEAD, ...             % from
    cIndex.indexLeftchild, ...        % from_type
    {mtree.K.ID, config.switchingFunctionOutputName});

% Delete everything after the new return
mtree.T(mtree_rIndexFunctionIndex.Expr(functionCallIndex), mtree_cIndex().indexNextNode) = 0;
end
