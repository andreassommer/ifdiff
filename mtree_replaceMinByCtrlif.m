function [mtreeobj, ctrlif_index] = mtree_replaceMinByCtrlif(mtreeobj, ctrlif_index)
% obj = replaceminByctrlif(mtreeobj)
%
% replace all min, min calls by ctrlif calls;
%
% 1.e. z = min(a,b) ->
%     temp_arg1 = a;
%     temp_arg2 = b;
%     z = ctrlif(a-b >= 0, temp_arg1, temp_arg2, index, datahandle)
%
%
%
% INPUT:
%       'mtreeobj': mtreeobj from rhs function
%
% OUTPUT:
%       'obj': mtreeobj where all min, min are replaced by ctrlif
%       function calls.

% Author:
% Valentin von Trotha, 2020

% History: June 2020 --> created

% notation:
% cIndex -> column index; refers to a property type
% rIndex -> row index of some object; refers to the entire row.
cIndex = mtree_cIndex();
rIndex = mtree_rIndex(mtreeobj);

% mtreeobj.T(length(mtreeobj.T)+1:length(mtreeobj.T)+1000,:) = zeros(1000,15);

% check if there are any min or min in mtreeobj, if not cancel calculation
if ~isfield(rIndex.BODY, 'min')
    % nothing to do
    return
end

mtreeobj = mtree_createSeparateFunctionCallInNewLine(mtreeobj,rIndex.BODY.min_call, 'min_'); 

rIndex = mtree_rIndex(mtreeobj);


% rIndex.BODY.minmin contains all indices of all min and min in a column vector
% map through this column vector, min and min can be handled simultaneously
for i = 1:length(rIndex.BODY.min)
    
    % Procedure: w.l.o.g (without loss of generality) let's consider a min functon call
    %
    % Start: c = min(a,b);
    temp_min_arg1 = ['min' num2str(i) '_arg1'];
    [mtreeobj, newArg1] = mtree_extractArgIntoNewLineAbove(mtreeobj, rIndex.BODY.min_Arg(i,1), temp_min_arg1);
    
    temp_min_arg2 = ['min' num2str(i) '_arg2'];
    [mtreeobj, newArg2] = mtree_extractArgIntoNewLineAbove(mtreeobj, rIndex.BODY.min_Arg(i,2), temp_min_arg2);
    
    
    % add minus node
    % c = min(b-a),
    [mtreeobj, rIndex.new.minusNd] = mtree_createAndAdd_NewNode(mtreeobj, ...
        rIndex.BODY.min_call(i), ...                                  % from
        cIndex.indexRightchild, ...                                      % from_type
        mtreeobj.K.MINUS, ...                                            % kind of Node
        [newArg1, newArg2], ...    % to
        [cIndex.indexRightchild, cIndex.indexLeftchild]);                % to_type
    
    mtreeobj.T(newArg1, cIndex.indexNextNode) = 0;
    
    
    [mtreeobj, ~] = preprocess_setUpCtrlif(mtreeobj, ...
        rIndex.BODY.min_Equals(i), ...
        ctrlif_index, ... 
        rIndex.new.minusNd, ...
        temp_min_arg1, ...
        temp_min_arg2);
    ctrlif_index = ctrlif_index + 1; 
    
end

end











