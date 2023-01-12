function [switchingFcn, n] = setUpSwitchingFunction_checkForExistensOfSwitchingFunction(switchingFcn, fcn_name_new, fcn_name_old)
% check if mtreeobj with name 'fcn_name' does already exist in
% .mtreeobj_switchingFcn. If not find the right one

cIndex = mtree_cIndex();


l1 = size(switchingFcn.mtreeobj_switchingFcn,2);
for i = 1:l1
    if strcmp(fcn_name_new, switchingFcn.mtreeobj_switchingFcn{1,i})
        n = i;
        return
    end
end

% does not exist yet

% find it in .mtreeobj
l2 = size(switchingFcn.mtreeobj,2);
for i = 1:l2
    if strcmp(fcn_name_old, switchingFcn.mtreeobj{2,i})
        index = l1 + 1;
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
        n = index; 
        return
    end
end



end