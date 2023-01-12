function [mtreeobj,ctrlif_index] = mtree_replaceAbsByCtrlif(mtreeobj, ctrlif_index)
% transform all abs into max, i.e. ('id est; latin for: that means, that is to say')
% b = abs(a);
%
% is changed into
%
% new_variable = a; 
% b = ctrlif(new_variable >= 0, new_variable, -new_variable, ...)
%
%

% notation:
% cIndex -> column index; refers to a property type
% rIndex -> row index of some object; refers to the entire row.
cIndex = mtree_cIndex();
rIndex = mtree_rIndex(mtreeobj);

% check if there are any abs in mtreeobj, if not cancel calculation
if ~isfield(rIndex.BODY, 'abs')
    % nothing to do
    return
end

config = makeConfig();

% when no '=' before 'abs', extract abs function into new line above
mtreeobj = mtree_createSeparateFunctionCallInNewLine(mtreeobj, rIndex.BODY.abs_call, config.abs.PrefixNewlineFcn);



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
    abs_argument_character_string = [config.abs.temp_abs_value, num2str(i)];
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





















