function mtree = replaceCtrlifByTrueOrFalse(mtree, ctrlif_index, switch_cond)
%REPLACECTRLIFBYTRUEORFALSE Replace a ctrlif with its true/false part.


cIndex = mtree_cIndex();

[rIndex_ctrlif, ctrlif_pos] = getCtrlifIndex(mtree);

idx = find(ctrlif_index == ctrlif_pos);

if switch_cond
    replacement = rIndex_ctrlif.ctrlif_Arg(idx,2);
else
    replacement = rIndex_ctrlif.ctrlif_Arg(idx,3);
end


mtree = mtree_connectNodes(...
    mtree, ...
    rIndex_ctrlif.ctrlif_Equals(idx), ...
    replacement, ...
    cIndex.indexRightchild);
end
