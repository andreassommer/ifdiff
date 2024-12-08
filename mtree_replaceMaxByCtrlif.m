function [mtreeobj, ctrlif_index] = mtree_replaceMaxByCtrlif(mtreeobj, ctrlif_index, ignores)
% [mtreeobj, ctrlif_index] = mtree_replaceMaxByCtrlif(mtreeobj, ctrlif_index, ignores)
%
% Replaces all max(...) calls in ´mtreeobj´ by ctrlif calls.
%
% 1.e. z = max(a,b) ->
%     temp_arg1 = a;
%     temp_arg2 = b;
%     z = ctrlif(a-b >= 0, temp_arg1, temp_arg2, index, datahandle)
%
%
%
% INPUT:
%       'mtreeobj': mtreeobj from rhs function
%
%       ´ctrlif_index´:     Current ctrlif_index counter.
%                           First ctrlif created in this function gets 
%                           ´ctrlif_index´+1 as its ctrlif_index.
%
%
% OUTPUT:
%       ´mtreeobj´:         Edited mtree. 
%                           All min, min are replaced by ctrlif function calls.
%
%       ´ctrlif_index´:     New ctrlif_index counter.
%
%
% Authors:
% Valentin von Trotha, 2020
% Michael Strik, 12/2024

config = makeConfig();
% notation:
% cIndex -> column index; refers to a property type
% rIndex -> row index of some object; refers to the entire row.
cIndex = mtree_cIndex();
rIndex = mtree_rIndex(mtreeobj);

% Is there any call to min in ´mtreeobj´?
if ~isfield(rIndex.BODY, 'max')
    % nothing to do
    return
end

mtreeobj = mtree_createSeparateFunctionCallInNewLine(mtreeobj,rIndex.BODY.max_call, config.maxCallPrefix);

rIndex = mtree_rIndex(mtreeobj);


for i = 1:length(rIndex.BODY.max)
    if ismember(rIndex.BODY.max(i), ignores)
        continue;
    end
    
    % Start: c = max(a,b);
    % Write a and b into their own variables
    name_max_arg1 = [config.maxCallPrefix, config.functionCallArgument1NameInfix, num2str(i)];
    [mtreeobj, newArg1] = mtree_extractArgIntoNewLineAbove(mtreeobj, rIndex.BODY.max_Arg(i,1), name_max_arg1);
    
    name_max_arg2 = [config.maxCallPrefix, config.functionCallArgument2NameInfix, num2str(i)];
    [mtreeobj, newArg2] = mtree_extractArgIntoNewLineAbove(mtreeobj, rIndex.BODY.max_Arg(i,2), name_max_arg2);

    % delete second argument of max
    mtreeobj.T(newArg1, cIndex.indexNextNode) = 0;
    mtreeobj.T(newArg2, cIndex.indexNextNode) = 0;


    % switchEval_max_i =  a - b
    % EXPR
    start_of_line = mtree_findBeginOfLine(mtreeobj, rIndex.BODY.max(i), mtreeobj.K.EXPR);
    [mtreeobj, switchEval_expr] = mtree_addNewExprNode(mtreeobj, start_of_line);
    % EQUALS
    % = ;
    [mtreeobj, switchEval_equals] = mtree_createAndAdd_NewNode(mtreeobj,...
        switchEval_expr, ...             % from
        cIndex.indexLeftchild, ...       % from_type
        mtreeobj.K.EQUALS);              % kind of new node
    % ID
    % switchEval_max_i = ;
    switchEvalName = [config.ctrlif.switchEvalName,'_max_',num2str(i)];
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj,...
        switchEval_equals, ...                  % from
        cIndex.indexLeftchild, ...              % from_type
        { mtreeobj.K.ID, switchEvalName });     % kind of new node: {kind, name}
    % MINUS
    % switchEval_max_i = a-b;
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        switchEval_equals, ...                  % from
        cIndex.indexRightchild, ...             % from_type
        mtreeobj.K.MINUS, ...                   % kind of Node
        [newArg1, newArg2], ...                 % to
        [cIndex.indexLeftchild, cIndex.indexRightchild]);   % to_type
    

 
    % setup ctrlif
    [mtreeobj, ~] = preprocess_setUpCtrlif(mtreeobj, ...
        rIndex.BODY.max_Equals(i), ...
        ctrlif_index, ... 
        switchEvalName, ...
        name_max_arg1, ...
        name_max_arg2, ...
        0);
    ctrlif_index = ctrlif_index + 1;

end

end
