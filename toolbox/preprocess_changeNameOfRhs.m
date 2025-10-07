function preprocessed = preprocess_changeNameOfRhs(preprocessed) 
cIndex = mtree_cIndex(); 
rIndex_head = mtree_rIndex_head(preprocessed.rhs{3,1}); 
cIndexFname = preprocessed.rhs{3,1}.T(rIndex_head.Fname, cIndex.stringTableIndex); 

preprocessed.rhs{3,1}.C{cIndexFname} = preprocessed.rhs{2,1}; 


end 