function [ctlrif_rIndex, ctrlif_pos] = getCtrlifIndex(mtree)
%GETCTRLIFINDEX Find index of ctrlifs
cIndex = mtree_cIndex();
config = makeConfig();

rIndex = struct('HEAD', struct(), 'BODY', struct());
rIndex.HEAD = mtree_rIndex_head(mtree, rIndex.HEAD);
rIndex.BODY = mtree_rIndex_function(mtree, rIndex.HEAD, rIndex.BODY, config.ctrlif.functionName);
if ~isfield(rIndex.BODY, config.ctrlif.functionName)
    error('Ctrlif not found!');
end
% TODO: What does this do???
ctrlif_pos = transpose(str2double(mtree.C(mtree.T(rIndex.BODY.ctrlif_Arg(:,4), cIndex.stringTableIndex))));
ctlrif_rIndex = rIndex.BODY;
end
