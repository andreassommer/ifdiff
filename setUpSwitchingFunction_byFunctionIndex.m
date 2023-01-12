function switchingFcn = setUpSwitchingFunction_byFunctionIndex(switchingFcn, i, j)
% replace every ctrlif with its truepart/ falsepart.
% map through all ctrlif's and function_indices and replace ctrlif.
% No switching function extracted here at the moment, this is not done
% here.
%
% switchingFcn: swichting function object containing all the relevant
%               information that a required for setting up a switchingfunction, like all
%               the mtreeplus objects.
% i: i-th function_index (refers to a vector)
% j: j-th element of the i-th function index (skalar number)

cIndex = mtree_cIndex();
function_index_i = switchingFcn.function_index_t1{i}; 

% check whether we are in rhs
ctrlifInRhs_true = (function_index_i(1) == 0); 


if ctrlifInRhs_true
    switchingFcn = setUpSwitchingFunction_removeCtrlifInRhs(switchingFcn,i,j); 
    return
end 


if j ~= length(switchingFcn.function_index_t1{i}) + 1
    
    switchingFcn = setUpSwitchingFunction_setUpFcnCall(switchingFcn, i, j);
    
else % here is the ctrlif to consider
    n = switchingFcn.nCurrentFunction;
    
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
    
    % reset to default
    switchingFcn.nCurrentFunction = 1; 
    
end

























end