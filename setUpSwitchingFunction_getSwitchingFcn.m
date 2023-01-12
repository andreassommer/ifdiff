function switchingFcn = setUpSwitchingFunction_getSwitchingFcn(switchingFcn)
config = makeConfig();
cIndex = mtree_cIndex;

l = length(switchingFcn.function_index_t1{switchingFcn.sI});
for j = 1:l + 1
    function_index_sI = switchingFcn.function_index_t1{switchingFcn.sI};
    
    % ctrlif with switching function found in rhs
    % ctrlif: new outputvariable, extract switchingfunction
    % remove function_index, datahandle from function
    % change output variable of function
    % change output variable of function call
    
    % if function_index_sI(1) == 0; then switch in rhs, no function call to consider
    if j == 1 && function_index_sI(j) == 0
        % find ctrlif
        % rhs: n = 1
        n = 1;
        % find out which ctrlif (e.g. first, second...) is the considered
        % ctrlif w.r.t to the function
        u = find(switchingFcn.ctrlif_index(switchingFcn.sI) == switchingFcn.mtreeobj_switchingFcn{6,n});
        
        rIndex_ctrlif = switchingFcn.mtreeobj_switchingFcn{7,n};
        % replace ctrlif by its thenpart/elsepart (resp. to the condition)
        
        ctrlif_cond = switchingFcn.mtreeobj_switchingFcn{3,n}.T(rIndex_ctrlif.ctrlif_Arg(u,1), cIndex.indexLeftchild);
        
        % new output variable for ctrlif
        [switchingFcn.mtreeobj_switchingFcn{3,n}, ~] = mtree_createAndAdd_NewNode(switchingFcn.mtreeobj_switchingFcn{3,n}, ...
            rIndex_ctrlif.ctrlif_Equals(u), ...              % from
            cIndex.indexLeftchild, ...                       % from_type
            {switchingFcn.mtreeobj_switchingFcn{3,n}.K.ID, config.switchingfunction.name_outputvariable});
        
        rIndex = struct('HEAD', struct(), 'BODY', struct());
        rIndex.HEAD = mtree_rIndex_head(switchingFcn.mtreeobj_switchingFcn{3,n}, rIndex.HEAD);
        
        % new output variable for rhs
        [switchingFcn.mtreeobj_switchingFcn{3,n}, ~] = mtree_createAndAdd_NewNode(switchingFcn.mtreeobj_switchingFcn{3,n}, ...
            rIndex.HEAD.HEAD, ...                     % from
            cIndex.indexLeftchild, ...                % from_type
            {switchingFcn.mtreeobj_switchingFcn{3,n}.K.ID, config.switchingfunction.name_outputvariable});      % new variable
        
        % receive switching function from condition of ctrlif
        switchingFcn.mtreeobj_switchingFcn{3,n} = mtree_connectNodes(...
            switchingFcn.mtreeobj_switchingFcn{3,n}, ...
            rIndex_ctrlif.ctrlif_Equals(u), ...
            ctrlif_cond, ...
            cIndex.indexRightchild);
        
        % delete everything after the ctrlif
        switchingFcn.mtreeobj_switchingFcn{3,n}.T(rIndex_ctrlif.ctrlif_expr(u),cIndex.indexNextNode) = 0;
        
                
        switchingFcn.mtreeobj_switchingFcn{3,n} = setUpSwitchingFunction_handleIfCondition(...
            switchingFcn.mtreeobj_switchingFcn{3,n}, rIndex_ctrlif.ctrlif_expr(u), rIndex);
        
        return
    end
    
    % ctrlif with switching function found in some function (not rhs)
    % ctrlif: new outputvariable, extract switchingfunction
    % remove function_index, datahandle from function
    % change output variable of function
    % change output variable of function call
    if j == l + 1
        n = switchingFcn.nCurrentFunction;
        % find out which ctrlif (e.g. first, second...) is the considered
        % ctrlif w.r.t to the function
        u = find(switchingFcn.ctrlif_index(switchingFcn.sI) == switchingFcn.mtreeobj_switchingFcn{6,n});
        
        rIndex_ctrlif = switchingFcn.mtreeobj_switchingFcn{7,n};
        % replace ctrlif by its thenpart/elsepart (resp. to the condition)
        
        
        % new output variable for ctrlif
        [switchingFcn.mtreeobj_switchingFcn{3,n}, ~] = mtree_createAndAdd_NewNode(switchingFcn.mtreeobj_switchingFcn{3,n}, ...
            rIndex_ctrlif.ctrlif_Equals(u), ...              % from
            cIndex.indexLeftchild, ...                       % from_type
            {switchingFcn.mtreeobj_switchingFcn{3,n}.K.ID, config.switchingfunction.name_outputvariable});
        
        ctrlif_cond = switchingFcn.mtreeobj_switchingFcn{3,n}.T(rIndex_ctrlif.ctrlif_Arg(u,1), cIndex.indexLeftchild);
        
        rIndex = struct('HEAD', struct(), 'BODY', struct());
        rIndex.HEAD = mtree_rIndex_head(switchingFcn.mtreeobj_switchingFcn{3,n}, rIndex.HEAD);
        
        % new output variable for rhs
        [switchingFcn.mtreeobj_switchingFcn{3,n}, ~] = mtree_createAndAdd_NewNode(switchingFcn.mtreeobj_switchingFcn{3,n}, ...
            rIndex.HEAD.HEAD, ...                     % from
            cIndex.indexLeftchild, ...                % from_type
            {switchingFcn.mtreeobj_switchingFcn{3,n}.K.ID, config.switchingfunction.name_outputvariable});      % new variable
        
        % receive switching function from condition of ctrlif
        switchingFcn.mtreeobj_switchingFcn{3,n} = mtree_connectNodes(...
            switchingFcn.mtreeobj_switchingFcn{3,n}, ...
            rIndex_ctrlif.ctrlif_Equals(u), ...
            ctrlif_cond, ...
            cIndex.indexRightchild);

        % delete everything after the ctrlif
        switchingFcn.mtreeobj_switchingFcn{3,n}.T(rIndex_ctrlif.ctrlif_expr(u),cIndex.indexNextNode) = 0;
        
                
        switchingFcn.mtreeobj_switchingFcn{3,n} = setUpSwitchingFunction_handleIfCondition(...
            switchingFcn.mtreeobj_switchingFcn{3,n}, rIndex_ctrlif.ctrlif_expr(u), rIndex);


        
    end
    
    
    % no ctrlif,
    % remove function_index, datahandle from function
    % change output variable of function
    % change name of the function
    % change output variable of function call
    % remove function_index, datahandle from function call
    if j < l + 1
        switchingFcn = setUpSwitchingFunction_getSwitchingFcn_noSwitch(switchingFcn, switchingFcn.sI, j);
    end
    
end














end













