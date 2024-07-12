function [mtreeobj, Arg1] = preprocess_setUpCtrlif(mtreeobj, index, ctrlif_index, varargin)
% function for adding crtlfif to mtreeobj at Node of rIndex
% Input and output depend on the chosen case and are explained there
% This function tries to generalise the assembling of the ctrlif
cIndex = mtree_cIndex();

config = makeConfig();


% index has to be equal node
% adds ctrlif(>=0) to equal node and connects >= to condition, either
% a new variable or an index
% new_index (output) is node of '>=' node, add Arg2 with nextNode to >=

condition = varargin{1};
truepart = varargin{2};
elsepart = varargin{3};

[mtreeobj, call] = mtree_createAndAdd_NewNode(mtreeobj, ...
    index, ...                              % from
    cIndex.indexRightchild, ...             % from_type
    mtreeobj.K.CALL);                       % kind of Node; character string of new var

[mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
    call, ...                                              % from
    cIndex.indexLeftchild, ...                             % from_type
    {mtreeobj.K.ID, config.ctrlif.functionName});

[operator_type, ~] = mtree_checkForComparisonOperator(mtreeobj, condition);

if ischar(condition)
    [mtreeobj, Arg1] = mtree_createAndAdd_NewNode(mtreeobj, ...
        call, ...                                         % from
        cIndex.indexRightchild,...                           % from_type
        mtreeobj.K.GE);
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        Arg1, ...                                         % from
        cIndex.indexLeftchild, ...                        % from_type
        {mtreeobj.K.ID, condition});
    
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        Arg1, ...                                         % from
        cIndex.indexRightchild, ...                       % from_type
        {mtreeobj.K.ID, '0'});
elseif operator_type == 0
    
    
    [mtreeobj, Arg1] = mtree_createAndAdd_NewNode(mtreeobj, ...
        call, ...                                         % from
        cIndex.indexRightchild, ...                       % from_type
        mtreeobj.K.GE, ...
        condition, ...
        cIndex.indexLeftchild);
    
    [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
        Arg1, ...                                         % from
        cIndex.indexRightchild, ...                       % from_type
        {mtreeobj.K.ID, '0'});
    
elseif  operator_type ~= 0
    mtreeobj = mtree_connectNodes(mtreeobj, call, condition,  cIndex.indexRightchild);
    Arg1 = condition;
end

ctrlif_index_Arg4 = num2str(ctrlif_index); 
[mtreeobj, Arg2] = preprocess_setUpCtrlif_addArgument(mtreeobj, Arg1, truepart, cIndex.indexNextNode);
[mtreeobj, Arg3] = preprocess_setUpCtrlif_addArgument(mtreeobj, Arg2, elsepart, cIndex.indexNextNode);
[mtreeobj, Arg4] = preprocess_setUpCtrlif_addArgument(mtreeobj, Arg3, ctrlif_index_Arg4, cIndex.indexNextNode);
[mtreeobj, Arg5] = preprocess_setUpCtrlif_addArgument(mtreeobj, Arg4, config.function_indexArgumentName, cIndex.indexNextNode);
[mtreeobj, ~] = preprocess_setUpCtrlif_addArgument(mtreeobj, Arg5, config.datahandleArgumentName, cIndex.indexNextNode);


% get condition into 'expression >= 0' shape
% Arg1 and Arg2 are switched sometimes, therefore do it in the end
mtreeobj = normFormExecCtrlif(mtreeobj, Arg1, Arg2, Arg3, Arg4);




end














