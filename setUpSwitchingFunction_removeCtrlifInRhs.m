function switchingFcn = setUpSwitchingFunction_removeCtrlifInRhs(switchingFcn,i,~)

cIndex = mtree_cIndex; 
% 
n = 1; 
% find out which ctrlif (e.g. first, second...) is the considered
% ctrlif w.r.t to the function
u = find(switchingFcn.ctrlif_index(i) == switchingFcn.mtreeobj_switchingFcn{6,n});

rIndex_ctrlif = switchingFcn.mtreeobj_switchingFcn{7,n};
% replace ctrlif by its thenpart/elsepart (resp. to the condition)

if switchingFcn.condition(i)
    switchingFcn.mtreeobj_switchingFcn{3,n} = mtree_connectNodes(...
        switchingFcn.mtreeobj_switchingFcn{3,n}, ...
        rIndex_ctrlif.ctrlif_Equals(u), ...
        rIndex_ctrlif.ctrlif_Arg(u,2), ...
        cIndex.indexRightchild);
else
    switchingFcn.mtreeobj_switchingFcn{3,n} = mtree_connectNodes(...
        switchingFcn.mtreeobj_switchingFcn{3,n}, ...
        rIndex_ctrlif.ctrlif_Equals(u), ...
        rIndex_ctrlif.ctrlif_Arg(u,3), ...
        cIndex.indexRightchild);
end




end