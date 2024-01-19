function [mtreeobj, ctrlif_index] = mtree_replaceIfByCtrlif(mtreeobj, ctrlif_index)
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
mtree_strings = mtreeobj.strings();
commentnodes = mtree_mtfind(mtreeobj, 'Kind', mtreeobj.K.COMMENT);
comments = mtree_strings(commentnodes);
comments_ignore_index = checkString(comments) == 1; % Keine Ahnung ob das eine gute Syntax ist
comment_nodes_ignore = commentnodes(comments_ignore_index);

j = 1;
% handle each if node seperately
for i = 1:length(rIndex.BODY.IF)
    


    if j<=length(comment_nodes_ignore)  % "loop" over index for if heads to be ignored
        if i<length(rIndex.BODY.IF) % handle last if body node seperate
            if and(rIndex.BODY.IF(i)<comment_nodes_ignore(j) , rIndex.BODY.IF(i+1)>comment_nodes_ignore(j)) 
                % Idea: Should "BODY IF Index(i) < Comment_node ignore < BODY
                % IF Index (i+1)" be true, the comment which is to be
                % ignored lies between those point.
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
    % add ctrlif before the if
    
    
    % start with:
    % if condition
    % ...
    [mtreeobj, rIndex.new.ctrlif_expr] = mtree_addNewExprNode(mtreeobj, rIndex.BODY.IF(i));
    
    
    
    % add equals node
    %
    % = ;
    % if condition
    % ...
    [mtreeobj, ctrlif_Equals] = mtree_createAndAdd_NewNode(mtreeobj,...
        rIndex.new.ctrlif_expr, ...                         % from
        cIndex.indexLeftchild, ...                          % from_type
        mtreeobj.K.EQUALS);                                 % kind of new node
    
    
    % add output variable of ctrlif
    %
    % conditionValue = ;
    % if condition
    % ...
    
    
    
    % node needs to be the expr node the ctrlif
    % only with if conditions
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj,...
        ctrlif_Equals, ...                                    % from
        cIndex.indexLeftchild, ...                            % from_type
        {mtreeobj.K.ID, config.ctrlif.Out});                  % kind of new node
    
    
    % add call node for ctrlif function call with connection to condition
    %
    % conditionValue = ctrl(condition);
    % if condition
    % ...
    [mtreeobj, ~] = preprocess_setUpCtrlif(mtreeobj,...
        ctrlif_Equals, ...
        ctrlif_index, ...
        rIndex.BODY.cond(i), ...
        'true', ...
        'false');
    ctrlif_index = ctrlif_index + 1; 
    
    % 'condition' -> 'conditionValue'
    %
    % conditionValue = ctrlif(condition)
    % if conditionValue
    % ...
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        rIndex.BODY.IFHEAD(i), ...                            % from
        cIndex.indexLeftchild, ...                            % from_type
        {mtreeobj.K.ID, config.ctrlif.Out});                  % kind of new node
    
end

end % finito





