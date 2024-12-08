function [mtreeobj, Arg1] = preprocess_setUpCtrlif(mtreeobj, index, ctrlif_index, switchInput, truepart, elsepart, operator_type)
% function for adding ctrlif to mtreeobj at Node of rIndex
% Input and output depend on the chosen case and are explained there
% This function tries to generalise the assembling of the ctrlif
%
% INPUT:
% ´mtreeobj´            mtree
%
% ´index´               Index at which to add the ctrlif. Has to be an EQUALS node.
%                       The ctrlif call becomes its right child.
%
% ´ctrlif_index´        The ctrlif_index passed to the new ctrlif.
%
% ´switchInput´         (chararray)
%                       Identifier, first argument that ctrlif gets.
%
% ´truepart´            (chararray)
%                       The truepart passed to the new ctrlif.
%                       Must be 'true' or 'false'.
%
% ´elsepart´            (chararray)
%                       The elsepart passed to the new ctrlif.
%                       Must be 'true' or 'false'.
%
% 'operator_type'       The type of operator that the switch contains 
%                       in its original if-statement
%                       (or equivalent formulation as if-statement).
%
%
% OUTPUT:
% ´mtreeobj´            Edited mtree.
% ´Arg1´                First argument of ctrlif.

cIndex = mtree_cIndex();

config = makeConfig();


% at ´index´ there has to be an EQUAL node
% adds ctrlif(...) call as right child to EQUAL node

% add node; CALL
[mtreeobj, call] = mtree_createAndAdd_NewNode(mtreeobj, ...
    index, ...                              % from
    cIndex.indexRightchild, ...             % from_type
    mtreeobj.K.CALL);                       % kind of Node; character string of new var

% add node; ID: ctrlif
[mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
    call, ...                                              % from
    cIndex.indexLeftchild, ...                             % from_type
    {mtreeobj.K.ID, config.ctrlif.functionName});

% write (val - offset) >= 0 into first argument
if ischar(switchInput)
    % switchInput gets interpreted as an identifier (ID).
    % Write 'switchInput' into first argument of ctrlif.
    [mtreeobj, Arg1] = mtree_createAndAdd_NewNode(mtreeobj, ...
        call, ...                                         % from
        cIndex.indexRightchild, ...                        % from_type
        {mtreeobj.K.ID, switchInput});
end

ctrlif_index_Arg4 = num2str(ctrlif_index);
[mtreeobj, Arg2] = preprocess_setUpCtrlif_addArgument(mtreeobj, Arg1, truepart, cIndex.indexNextNode);
[mtreeobj, Arg3] = preprocess_setUpCtrlif_addArgument(mtreeobj, Arg2, elsepart, cIndex.indexNextNode);
[mtreeobj, Arg4] = preprocess_setUpCtrlif_addArgument(mtreeobj, Arg3, ctrlif_index_Arg4, cIndex.indexNextNode);
[mtreeobj, Arg5] = preprocess_setUpCtrlif_addArgument(mtreeobj, Arg4, config.function_indexArgumentName, cIndex.indexNextNode);
[mtreeobj, ~   ] = preprocess_setUpCtrlif_addArgument(mtreeobj, Arg5, config.datahandleArgumentName, cIndex.indexNextNode);


% get condition into 'expression >= 0' shape
% If the operator is a strict lower or equal, we need a negation in the
% transformation of the condition to normal form.
% In the ctrlif, truepart and elsepart need to be switched therefore, i.e.,
% we switch their positions in the input arguments.
if (operator_type == mtreeobj.K.LT || operator_type == mtreeobj.K.GT)
        mtreeobj = normFormExecCtrlif_switchThenAndElsePart(mtreeobj, Arg1, Arg2, Arg3, Arg4); 
end


end