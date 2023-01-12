function preprocessed = preprocess_setFunctionIndexInRhs(preprocessed) 

rIndex = struct('HEAD', struct(), 'BODY', struct()); 
config = makeConfig(); 
cIndex = mtree_cIndex; 
rIndex.BODY = mtree_rIndex_function(preprocessed.rhs{3,1}, rIndex.BODY, config.ctrlif.ctrlif); 

if ~isfield(rIndex.BODY, 'ctrlif') 
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