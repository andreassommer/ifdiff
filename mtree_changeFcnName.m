function mtreeobj = mtree_changeFcnName(mtreeobj, name)
% change name of function to 'name' 
% mtreeobj: mtreeplus object 
% name: string with new name 
cIndex = mtree_cIndex; 
% get head structure 
rIndex = struct('HEAD', struct(), 'BODY', struct());
rIndex.HEAD = mtree_rIndex_head(mtreeobj, rIndex.HEAD);


% change name of function
[mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
    rIndex.HEAD.ETC2, ...                     % from
    cIndex.indexLeftchild, ...                % from_types
    {mtreeobj.K.ID, name});



end