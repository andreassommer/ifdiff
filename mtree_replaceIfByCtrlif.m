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



% handle each if node seperately
for i = 1:length(rIndex.BODY.IF)
    
    if mtree_ifdiff_ignore(mtreeobj, rIndex.BODY.IF(i))
        % skip this if-statement if the user specifies so
        continue
    end
    
    cond_feasible = mtree_checkFeasibilityOfCondition(mtreeobj, rIndex.BODY.cond(i));
    if ~cond_feasible
        continue
        warning('An if condition is not feasible and was not replaced by a ctrlif.');
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
        {mtreeobj.K.ID, config.ctrlif.outputName});           % kind of new node
    
    
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
        {mtreeobj.K.ID, config.ctrlif.outputName});           % kind of new node
    
end

end % finito





