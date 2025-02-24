function [mtreeobj, ctrlif_index] = mtree_replaceSignByCtrlif(mtreeobj, ctrlif_index, ignores)
% Replace every call of sign(...) by an (almost) equivalent call of ctrlif(...).
% b = sign(a);
%
% is changed into
%
% new_variable = a; 
% b = ctrlif(new_variable, ...)
%

% notation:
% rIndex -> row index of some object; refers to the entire row.
rIndex = mtree_rIndex(mtreeobj);

% check if there are any sign in mtreeobj, if not cancel calculation
if ~isfield(rIndex.BODY, 'sign')
    % nothing to do
    return
end

% prep
warning('sign() function found, sign(0) = 0 is modified to sign(0) = 1')

config = makeConfig();
rIndex = mtree_rIndex(mtreeobj);


% when no '=' before 'sign', extract sign function into new line that assigns it to a variable
mtreeobj = mtree_createSeparateFunctionCallInNewLine(mtreeobj, rIndex.BODY.sign_call, config.signCallPrefix);
rIndex = mtree_rIndex(mtreeobj);

for i = 1:length(rIndex.BODY.sign)
    if ismember(rIndex.BODY.sign(i), ignores)
        continue;
    end

    switchEvalName = [config.ctrlif.switchEvalName, '_sign_', num2str(i)];
    [mtreeobj, ~] = mtree_extractArgIntoNewLineAbove(mtreeobj, rIndex.BODY.sign_Arg(i), switchEvalName); 

    [mtreeobj, ~] = preprocess_setUpCtrlif( ...
        mtreeobj,...
        rIndex.BODY.sign_Equals(i), ...         % equals node for ctrlif
        ctrlif_index, ...
        switchEvalName, ...                     % switchInput
        '1', ...                                % truepart
        '-1', ...                               % elsepart
        0);                                  
    ctrlif_index = ctrlif_index + 1;
end

end
