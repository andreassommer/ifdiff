function mtree = replaceCtrlifByReturn(mtree, outputName, ctrlif_index)
%REPLACECTRLIFBYRETURN  Replace a ctrlif with a return statement containing its evaluated condition
cIndex = mtree_cIndex;

[rIndex_ctrlif, ctrlif_pos] = getCtrlifIndex(mtree);

% map the global ctrlif index, sI, to the ctrlif index (1st, 2nd, ...) within the considered function
idx = find(ctrlif_index == ctrlif_pos);


ctrlif_cond = rIndex_ctrlif.ctrlif_Arg(idx, 1);

% new output variable for ctrlif
[mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
    rIndex_ctrlif.ctrlif_Equals(idx), ...              % from
    cIndex.indexLeftchild, ...                       % from_type
    {mtree.K.ID, outputName});

rIndex = struct('HEAD', struct(), 'BODY', struct());
rIndex.HEAD = mtree_rIndex_head(mtree, rIndex.HEAD);

% new output variable for rhs
[mtree, ~] = mtree_createAndAdd_NewNode(mtree, ...
    rIndex.HEAD.HEAD, ...                     % from
    cIndex.indexLeftchild, ...                % from_type
    {mtree.K.ID, outputName});      % new variable

% receive switching function from condition of ctrlif
mtree = mtree_connectNodes(...
    mtree, ...
    rIndex_ctrlif.ctrlif_Equals(idx), ...
    ctrlif_cond, ...
    cIndex.indexRightchild);

mtree = traceReturnStatementToInputs(mtree, rIndex_ctrlif.ctrlif_expr(idx));
end
