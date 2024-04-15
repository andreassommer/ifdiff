function [mtreeobj, ctrlif_index] = mtree_replaceIfByCtrlif_new(mtreeobj, ctrlif_index)
% add ctrlif before every if condition
%
% Example:
%
% if cond
% ...
% end
%
% is changed to
%
% condValue = ctrlif(cond, true, false, index, datahandle);
% if condValue
% ...
% end
%
%
% INPUT: 'mtreeobj' -> mtreeobj of rhs
%
% OUTPUT:
%
config = makeConfig();

% notation:
% cIndex -> column index; refers to a property type
% rIndex -> row index of some object; refers to the entire row.
cIndex = mtree_cIndex();
rIndex = mtree_rIndex(mtreeobj);

% for every if statement add a ctrlif function call
if ~isfield(rIndex.BODY, 'IF')
    % nothing to do
    return
end
% mtree_strings = mtreeobj.strings();
% commentnodes = mtree_mtfind(mtreeobj, 'Kind', mtreeobj.K.COMMENT);
% comments = mtree_strings(commentnodes);
% comments_ignore_index = checkString(comments) == 1;
% comment_nodes_ignore = commentnodes(comments_ignore_index);

comment_nodes_ignore = getIfNodesToBeIgnored(mtreeobj);
j = 1;
% handle each if node seperately
for i = 1:length(rIndex.BODY.IF)
    


    if j<=length(comment_nodes_ignore)  % "loop" over "if heads to be ignored"
        if i<length(rIndex.BODY.IF) % handle last if body node seperate
            if and(rIndex.BODY.IF(i)<comment_nodes_ignore(j) , rIndex.BODY.IF(i+1)>comment_nodes_ignore(j)) 
                % Idea: Should "BODY IF Index(i) < Comment_node ignore < BODY
                % IF Index (i+1)" be true, the comment which is to be
                % ignored lies between those points and hence, the if else part should remain the same.
                j = j+1;
                    
                continue
            end
        else % Last if body node
            if rIndex.BODY.IF(i)<comment_nodes_ignore(j)
                j = j+1;
                
                continue
            end
        end
    end




    cond_feasible = mtree_checkFeasibilityOfCondition(mtreeobj, rIndex.BODY.cond(i));
    if ~cond_feasible
        continue
    end



    name_branch = append(config.ctrlif.prefix, num2str(ctrlif_index), config.ctrlif.branch);
    name_value = append(config.ctrlif.prefix, num2str(ctrlif_index), config.ctrlif.value);
    name_logical = append(config.ctrlif.prefix, num2str(ctrlif_index), config.ctrlif.logical);
    % add ctrlif before the if
    
    

    % Adding Expression Nodes 
    [mtreeobj, rIndex.new.ctrlif_branch] = mtree_addNewExprNode(mtreeobj, rIndex.BODY.IF(i));
    [mtreeobj, rIndex.new.ctrlif_logical] = mtree_addNewExprNode(mtreeobj, rIndex.new.ctrlif_branch);
    [mtreeobj, rIndex.new.ctrlif_value] = mtree_addNewExprNode(mtreeobj, rIndex.new.ctrlif_logical);

    % Value
    [mtreeobj, ctrlif_expr_value] = mtree_createAndAdd_NewNode(mtreeobj,...
        rIndex.new.ctrlif_value, ...                         % from
        cIndex.indexLeftchild, ...                          % from_type
        mtreeobj.K.EQUALS);                                 % kind of new node


    [mtreeobj, rIndex.new.valueID] = mtree_createAndAdd_NewNode(mtreeobj,...
        ctrlif_expr_value, ...                                    % from
        cIndex.indexLeftchild, ...                            % from_type
        {mtreeobj.K.ID, name_value});                  % kind of new node
   
    % Das hier macht noch zu viel bzw nicht das erwuenschte
    
    obj = mtree_transformIfCondition(mtreeobj, ...
        ctrlif_expr_value, ...
        ctrlif_index, ...
        rIndex.BODY.cond(i), ...
        'true', ...
        'false');
    mtreeobj = mtree_connectNodes(obj, ctrlif_expr_value, a,  cIndex.indexRightchild);


    % Logical
    [mtreeobj, ctrlif_expr_logical] = mtree_createAndAdd_NewNode(mtreeobj,...
        rIndex.new.ctrlif_logical, ...                         % from
        cIndex.indexLeftchild, ...                          % from_type
        mtreeobj.K.EQUALS);                                 % kind of new node


    [mtreeobj, rIndex.new.logcial] = mtree_createAndAdd_NewNode(mtreeobj,...
        ctrlif_expr_logical, ...                                    % from
        cIndex.indexLeftchild, ...                            % from_type
        {mtreeobj.K.ID, name_logical});                  % kind of new node

    [mtreeobj, Arg1] = mtree_createAndAdd_NewNode(mtreeobj, ...
        ctrlif_expr_logical, ...                                         % from
        cIndex.indexRightchild, ...                       % from_type
        mtreeobj.K.GE, ...
        rIndex.new.valueID, ...
        cIndex.indexLeftchild);
    
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        Arg1, ...                                         % from
        cIndex.indexRightchild, ...                       % from_type
        {mtreeobj.K.ID, '0'});
    % Branch
    

    [mtreeobj, ctrlif_expr_branch] = mtree_createAndAdd_NewNode(mtreeobj,...
        rIndex.new.ctrlif_branch, ...                         % from
        cIndex.indexLeftchild, ...                          % from_type
        mtreeobj.K.EQUALS);                                 % kind of new node
    
    
    % node needs to be the expr node the ctrlif
    % only with if conditions
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj,...
        ctrlif_expr_branch, ...                                    % from
        cIndex.indexLeftchild, ...                            % from_type
        {mtreeobj.K.ID, name_branch});                  % kind of new node
    
    
    %Setup 
    [mtreeobj, ~] = preprocess_setUpCtrlif(mtreeobj,...
        ctrlif_expr_branch, ...
        ctrlif_index, ...
        rIndex.new.logcial, ... %   Alt: rIndex.BODY.cond(i)
        'true', ...
        'false');
   
    % 
    % 
    
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        rIndex.BODY.IFHEAD(i), ...                            % from
        cIndex.indexLeftchild, ...                            % from_type
        {mtreeobj.K.ID, name_branch});                  % kind of new node
    
    ctrlif_index = ctrlif_index + 1; 

    %%%%% Ueberlegung
    % Add ID (ifdiff condition value)
    % Add Equals
    % Add Condition
    % 
    % Add ID condition_logical Valie
    % Add Equal Node
    % Add Expression evaluation (possible multiple Nodes)
    %
    %
    %
    %
    %
    %
    
end

end % finito





