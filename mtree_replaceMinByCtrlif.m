function [mtreeobj, ctrlif_index] = mtree_replaceMinByCtrlif(mtreeobj, ctrlif_index, ignores)
% [mtreeobj, ctrlif_index] = mtree_replaceMinByCtrlif(mtreeobj, ctrlif_index)
%
%
% Replace all min(...) calls in ´mtreeobj´ by ctrlif calls.
%
% 1.e. z = min(a,b) ->
%     temp_arg1 = a;
%     temp_arg2 = b;
%     z = ctrlif(a-b, temp_arg1, temp_arg2, index, datahandle)
%
%
%
% INPUT:
%       ´mtreeobj´:         mtree
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
if ~isfield(rIndex.BODY, 'min')
    % nothing to do
    return
end

mtreeobj = mtree_createSeparateFunctionCallInNewLine(mtreeobj,rIndex.BODY.min_call, config.minCallPrefix);

rIndex = mtree_rIndex(mtreeobj);


for i = 1:length(rIndex.BODY.min)
    if ismember(rIndex.BODY.min(i), ignores)
        continue;
    end
    
    % Start: c = min(a,b);
    % Write a and b into their own variables
    name_min_arg1 = [config.minCallPrefix, config.functionCallArgument1NameInfix, num2str(i)];
    [mtreeobj, newArg1] = mtree_extractArgIntoNewLineAbove(mtreeobj, rIndex.BODY.min_Arg(i,1), name_min_arg1);
    
    name_min_arg2 = [config.minCallPrefix, config.functionCallArgument2NameInfix, num2str(i)];
    [mtreeobj, newArg2] = mtree_extractArgIntoNewLineAbove(mtreeobj, rIndex.BODY.min_Arg(i,2), name_min_arg2);
    
    % delete second argument of max
    mtreeobj.T(newArg1, cIndex.indexNextNode) = 0; 
    mtreeobj.T(newArg2, cIndex.indexNextNode) = 0; 
    

    % switchEval_min_i =  b - a 
    % EXPR
    start_of_line = mtree_findBeginOfLine(mtreeobj, rIndex.BODY.min(i), mtreeobj.K.EXPR);
    [mtreeobj, switchEval_expr] = mtree_addNewExprNode(mtreeobj, start_of_line);
    % EQUALS
    % = ;
    [mtreeobj, switchEval_equals] = mtree_createAndAdd_NewNode(mtreeobj,...
        switchEval_expr, ...             % from
        cIndex.indexLeftchild, ...       % from_type
        mtreeobj.K.EQUALS);              % kind of new node
    % ID
    % switchEval_min_i = ;
    switchEvalName = [config.ctrlif.switchEvalName,'_min_',num2str(i)];
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj,...
        switchEval_equals, ...                  % from
        cIndex.indexLeftchild, ...              % from_type
        { mtreeobj.K.ID, switchEvalName });     % kind of new node: {kind, name}
    % MINUS
    % switchEval_min_i = b-a,
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        switchEval_equals, ...                              % from
        cIndex.indexRightchild, ...                         % from_type
        mtreeobj.K.MINUS, ...                               % kind of Node
        [newArg1, newArg2], ...                             % to
        [cIndex.indexRightchild, cIndex.indexLeftchild]);   % to_type


    
    % setup ctrlif
    [mtreeobj, ~] = preprocess_setUpCtrlif(mtreeobj, ...
        rIndex.BODY.min_Equals(i), ...
        ctrlif_index, ... 
        switchEvalName, ...
        name_min_arg1, ...
        name_min_arg2, ...
        0);
    ctrlif_index = ctrlif_index + 1; 
    
end

end
