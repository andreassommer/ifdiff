function [mtreeobj, ctrlif_index] = mtree_replaceSignByCtrlif(mtreeobj, ctrlif_index)
% transform all sign into max, i.e. ('id est; latin for: that means, that is to say')
% b = sign(a);
%
% is changed into
%
% new_variable = a; 
% b = ctrlif(new_variable >= 0, new_variable, -new_variable, ...)
%
%

% notation:
% rIndex -> row index of some object; refers to the entire row.
rIndex = mtree_rIndex(mtreeobj);

% check if there are any sign in mtreeobj, if not cancel calculation
if ~isfield(rIndex.BODY, 'sign')
    % nothing to do
    return
end

warning('sign() function found, sign(0) = 0 is modified to sign(0) = 1')

config = makeConfig();

mtreeobj = mtree_createSeparateFunctionCallInNewLine(mtreeobj, rIndex.BODY.sign_call, config.signCallPrefix);

rIndex = mtree_rIndex(mtreeobj);

for i = 1:length(rIndex.BODY.sign)
    
    [mtreeobj, ~] = preprocess_setUpCtrlif(mtreeobj,...
        rIndex.BODY.sign_Equals(i), ...         % equals node for ctrlif
        ctrlif_index, ...
        rIndex.BODY.sign_Arg(i,1), ...           % condition in Arg 1
        '1', ...                                % truepart
        '-1');                                  % elsepart
    ctrlif_index = ctrlif_index + 1;
end

end





















