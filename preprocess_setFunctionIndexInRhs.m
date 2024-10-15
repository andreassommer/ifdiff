function preprocessed = preprocess_setFunctionIndexInRhs(preprocessed)
% For every ctrlif call in the RHS, add a fourth argument, function_index, with the value 0

rIndex = struct('HEAD', struct(), 'BODY', struct());
config = makeConfig();
cIndex = mtree_cIndex;
rIndex.BODY = mtree_rIndex_function(preprocessed.rhs{3,1}, rIndex.BODY, config.ctrlif.functionName);

if ~isfield(rIndex.BODY, config.ctrlif.functionName)
    return
end

for i = 1:length(rIndex.BODY.ctrlif)
    [preprocessed.rhs{3,1}, ~] = mtree_createAndAdd_NewNode(preprocessed.rhs{3,1}, ...
        rIndex.BODY.ctrlif_Arg(i,4), ...
        cIndex.indexNextNode, ...
        {preprocessed.rhs{3,1}.K.ID, '0'}, ...
        rIndex.BODY.ctrlif_Arg(i,6), ...
        cIndex.indexNextNode);
end
end