function [mtreeobj, ctrlif_index] = mtree_replaceIifByCtrlif(mtreeobj, ctrlif_index)
% transform iif functions into ctrlif functions calls
%
% Example:
%
% iif(a-b > 0, a, b)
%
% is changed to
%
% ctlfif(a-b > 0, a, b, index, datahandle)
%
%
% INPUT:
% mtreeobj --> mtreeobj from rhs
%
% OUTPUT:
% obj --> mtreeobj, where all iif are replaced by ctrlif


% notation:
% cIndex -> column index; refers to a property type
% rIndex -> row index of some object; refers to the entire row.
% cIndex = mtree_cIndex(); 
rIndex = mtree_rIndex(mtreeobj);
config = makeConfig();


% check if there are any iif
if ~isfield(rIndex.BODY, 'IIf')
    % nothing to do
    return
end

mtreeobj = mtree_createSeparateFunctionCallInNewLine(mtreeobj, rIndex.BODY.IIf_call, config.abs.PrefixNewlineFcn);

rIndex = mtree_rIndex(mtreeobj);

for i = 1:length(rIndex.BODY.IIf)
    
    cond_feasible = mtree_checkFeasibilityOfCondition(mtreeobj, rIndex.BODY.cond); 
    if ~cond_feasible   
        continue
    end 
    
    [mtreeobj, ~] = preprocess_setUpCtrlif(mtreeobj,...
        rIndex.BODY.IIf_Equals(i), ...
        ctrlif_index, ... 
        rIndex.BODY.IIf_Arg(i,1), ...
        rIndex.BODY.IIf_Arg(i,2), ...
        rIndex.BODY.IIf_Arg(i,3));
    ctrlif_index = ctrlif_index + 1; 
end

end % finito






















