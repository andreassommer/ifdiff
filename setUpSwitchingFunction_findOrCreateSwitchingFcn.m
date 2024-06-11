function [switchingFcn, m] = setUpSwitchingFunction_findOrCreateSwitchingFcn(switchingFcn, fcn_name_new, fcn_name_old)
% check if mtreeobj with name 'fcn_name_new' exists in .mtreeobj_switchingFcn. If not, create a copy of
% fcn_name_old and store it in .mtreeobj_switchingFcn with the new name fcn_name_new

cIndex = mtree_cIndex();

nSwitchingFunctions = size(switchingFcn.mtreeobj_switchingFcn,2);
for i = 1:nSwitchingFunctions
    if strcmp(fcn_name_new, switchingFcn.mtreeobj_switchingFcn{1,i})
        m = i;
        return
    end
end

% does not exist yet, time to make a copy
nFunctions = size(switchingFcn.mtreeobj,2);
for i = 1:nFunctions
    if strcmp(fcn_name_old, switchingFcn.mtreeobj{2,i})
        index = nSwitchingFunctions + 1;
        switchingFcn.mtreeobj_switchingFcn(:,index) = switchingFcn.mtreeobj(:,i);
        
        rIndex = struct('HEAD', struct(), 'BODY', struct());
        rIndex.HEAD = mtree_rIndex_head(switchingFcn.mtreeobj_switchingFcn{3,index}, rIndex.HEAD);
        
        [switchingFcn.mtreeobj_switchingFcn{3,index}, ~] = mtree_createAndAdd_NewNode(switchingFcn.mtreeobj_switchingFcn{3,index}, ...
            rIndex.HEAD.ETC2, ...                     % from
            cIndex.indexLeftchild, ...                % from_types
            {switchingFcn.mtreeobj_switchingFcn{3,index}.K.ID, fcn_name_new});
        
        switchingFcn.mtreeobj_switchingFcn{3,index} = mtree_connectNodes(...
            switchingFcn.mtreeobj_switchingFcn{3,index}, ...
            rIndex.HEAD.ETC2,...
            rIndex.HEAD.Arg(1,3),...
            cIndex.indexRightchild);
        
        switchingFcn.mtreeobj_switchingFcn{1,index} = fcn_name_new; 
        m = index; 
        return
    end
end
end