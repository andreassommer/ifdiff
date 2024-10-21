function [mtreeobj,ctrlif_index] = mtree_replaceAbsByCtrlif(mtreeobj, ctrlif_index)
% transform all abs into ctrlif, e.g.:
% b = abs(a);
%
% is changed into
%
% new_variable = a; 
% b = ctrlif(new_variable >= 0, new_variable, -new_variable, ...)
%

cIndex = mtree_cIndex();
rIndex = mtree_rIndex(mtreeobj);

% check if there are any abs in mtreeobj, if not we are done
if ~isfield(rIndex.BODY, 'abs')
    % nothing to do
    return
end

config = makeConfig();

% when no '=' before 'abs', extract abs function into new line that assigns it to a variable
mtreeobj = mtree_createSeparateFunctionCallInNewLine(mtreeobj, rIndex.BODY.abs_call, config.absCallPrefix);

rIndex = mtree_rIndex(mtreeobj);

for i = 1:length(rIndex.BODY.abs)
    
    % new line above abs fcn call
    beginn_of_line = mtree_findBeginOfLine(mtreeobj, rIndex.BODY.abs_call(i), mtreeobj.K.EXPR);
    [mtreeobj, new_expr] = mtree_addNewExprNode(mtreeobj,beginn_of_line);
    
    % equal in new line 
    [mtreeobj, new_equal] = mtree_createAndAdd_NewNode(mtreeobj, ...
        new_expr, ...                        % from
        cIndex.indexLeftchild, ...           % from_type
        mtreeobj.K.EQUALS);                  % kind of Node
    
    % output arg of new line
    abs_argument_character_string = [config.absCallPrefix, config.functionCallArgumentNameInfix, num2str(i)];
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        new_equal, ...                                         % from
        cIndex.indexLeftchild, ...                             % from_type
        {mtreeobj.K.INT, abs_argument_character_string});      % kind of Node; character string of new var
    
    % refer output of new line to input of abs()
    mtreeobj = mtree_connectNodes(mtreeobj, new_equal, rIndex.BODY.abs_Arg(i,1), cIndex.indexRightchild);
        
    [mtreeobj,    ~] = preprocess_setUpCtrlif(mtreeobj,...
        rIndex.BODY.abs_Equals(i), ...
        ctrlif_index, ...
        abs_argument_character_string, ...
        abs_argument_character_string, ...
        ['-', abs_argument_character_string]);
        ctrlif_index = ctrlif_index + 1; 
end
end