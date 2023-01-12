function preprocessed = preprocess_rhs(preprocessed)
% preprocess rhs, i.e. transform all possible lines of code that could lead to a switch. 
% 
% obejcts of intereset: max, min, abs, sign and if-clauses. 
% either in the rhs or in a function that is being called within the rhs. 
% transform each of those elements of code such that it fits in the ctrlif
% structure. 
% 
% set function_index and set ctrlif_index 
% rename the functions that are being called and export then in a new file
% (we want to modify these functions and there need to copy them so that we dont might change the original function)

% transform functions max, min, abs, sign into ctrlifs and equip if-clauses with a ctrlif
[preprocessed.rhs{3,1}, preprocessed.ctrlif_index] = preprocess_addCtrlif(preprocessed.rhs{3,1}, 1);

% set function_index into code for each function call
preprocessed = preprocess_setFunctionIndexInRhs(preprocessed); 

preprocessed = preprocess_changeNameOfRhs(preprocessed); 
preprocessed.rhs{3,1} = preprocess_rhsAddDatahandleToInput(preprocessed.rhs{3,1});

% 'nargin' -> '(nargin + 1)'; if exists
preprocessed.rhs{3,1} = preprocess_handleNargin(preprocessed.rhs{3,1}, 1);

preprocessed = preprocess_fcnInRhs(preprocessed);


if ~isempty(preprocessed.fcn)
    [preprocessed.rhs{3,1}, preprocessed.function_index] = preprocess_adjustFcnCallsRhs(preprocessed.rhs{3,1}, 1, preprocessed.fcn, 1);
end


if isempty(preprocessed.fcn)
    return
end

l = size(preprocessed.fcn, 2);
for i = 1:l
    % 'nargin' -> 'nargin + 1'
    preprocessed.fcn{3,i} = preprocess_handleNargin(preprocessed.fcn{3,i}, 2);
    
    [preprocessed.fcn{3,i}, preprocessed.function_index] = preprocess_adjustFcnCallsRhs(...
        preprocessed.fcn{3,i}, 0, preprocessed.fcn, preprocessed.function_index);
end





end




