function [mtreeobj, ctrlif_index] = mtree_replaceMaxByCtrlif(mtreeobj, ctrlif_index)
% obj = replacemaxByctrlif(mtreeobj)
%
% replace all max, max calls by ctrlif calls;
%
% 1.e. z = max(a,b) ->
%     temp_arg1 = a;
%     temp_arg2 = b;
%     z = ctrlif(a-b >= 0, temp_arg1, temp_arg2, index, datahandle)
%
% if z = min(a,b) ->
%     temp_arg1 = a;
%     temp_arg2 = b;
%     z = ctrlif(b-a >= 0, temp_arg1, temp_arg2, index, datahandle)
%
%
% INPUT:
%       'mtreeobj': mtreeobj from rhs function
%
% OUTPUT:
%       'obj': mtreeobj where all max, max are replaced by ctrlif
%       function calls.

% Author:
% Valentin von Trotha, 2020


% notation:
% cIndex -> column index; refers to a property type
% rIndex -> row index of some object; refers to the entire row.
cIndex = mtree_cIndex();
rIndex = mtree_rIndex(mtreeobj);

% mtreeobj.T(length(mtreeobj.T)+1:length(mtreeobj.T)+1000,:) = zeros(1000,15);

% check if there are any max or max in mtreeobj, if not cancel calculation
if ~isfield(rIndex.BODY, 'max')
    % nothing to do
    return
end

mtreeobj = mtree_createSeparateFunctionCallInNewLine(mtreeobj,rIndex.BODY.max_call, 'max_'); 

rIndex = mtree_rIndex(mtreeobj);


% rIndex.BODY.maxmax contains all indices of all max and max in a column vector
% map through this column vector, max and max can be handled simultaneously
for i = 1:length(rIndex.BODY.max)
    
    % Procedure: w.l.o.g (without loss of generality) let's consider a max functon call
    %
    % Start: c = max(a,b);
    temp_max_arg1 = ['max' num2str(i) '_arg1'];
    [mtreeobj, newArg1] = mtree_extractArgIntoNewLineAbove(mtreeobj, rIndex.BODY.max_Arg(i,1), temp_max_arg1);
    
    temp_max_arg2 = ['max' num2str(i) '_arg2'];
    [mtreeobj, newArg2] = mtree_extractArgIntoNewLineAbove(mtreeobj, rIndex.BODY.max_Arg(i,2), temp_max_arg2);
    
    
    % add maxus node
    % c = max(b-a),
    [mtreeobj, rIndex.new.maxusNd] = mtree_createAndAdd_NewNode(mtreeobj, ...
        rIndex.BODY.max_call(i), ...                                     % from
        cIndex.indexRightchild, ...                                      % from_type
        mtreeobj.K.MINUS, ...                                            % kind of Node
        [newArg1, newArg2], ...                                          % to
        [cIndex.indexRightchild, cIndex.indexLeftchild]);                % to_type
    
    % delete second argument of max
    mtreeobj.T(newArg1, cIndex.indexNextNode) = 0;
    
    [mtreeobj, ~] = preprocess_setUpCtrlif(mtreeobj, ...
        rIndex.BODY.max_Equals(i), ...
        ctrlif_index, ... 
        rIndex.new.maxusNd, ...
        temp_max_arg2, ...
        temp_max_arg1);
    
    ctrlif_index = ctrlif_index + 1;
end

end









