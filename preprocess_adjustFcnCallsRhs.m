function [mtreeobj, function_index] = preprocess_adjustFcnCallsRhs(mtreeobj, is_mtreeobj_rhs, preprocessed_name, function_index)
% handle every function call of the function with the name in
% preprocessed_name
% add function_index and add datahandle as input variable
% create new line above the function call and set (functionindexX = updateFunctionIndex())
%



% notation:
% cIndex -> column index; refers to a property type
% rIndex -> row index of some object; refers to the entire row.
cIndex = mtree_cIndex();
config = makeConfig();
rIndex = mtree_rIndex(mtreeobj, preprocessed_name);

if isfield(rIndex, 'Fcn')
    field_names = fieldnames(rIndex.Fcn);
else
    return
end






for i = 1:length(fields(rIndex.Fcn))
    rIndex_Fcn_i = rIndex.Fcn.(field_names{i});
    Fname = mtreeobj.C{mtreeobj.T(rIndex_Fcn_i.Fname,cIndex.stringTableIndex)};
    
    mtreeobj = mtree_createSeparateFunctionCallInNewLine(mtreeobj, rIndex_Fcn_i.Call, Fname);
    
    new_rIndex = struct();
    rIndex_Fcn_i = mtree_rIndex_fcn(mtreeobj, Fname, new_rIndex);
    rIndex_Fcn_i = rIndex_Fcn_i.(Fname);
    
    for j = 1:length(rIndex_Fcn_i.Fname)
        
        newFname = preprocess_setUpNewFcnName(Fname); 
        
        % change functon name; add preprocess_ to the function name
        [mtreeobj, rIndex.Fcn.(field_names{i}).newFname(j)] = mtree_createAndAdd_NewNode(mtreeobj, ...
            rIndex_Fcn_i.Call(j), ...
            cIndex.indexLeftchild, ...
            {mtreeobj.K.ID, newFname});
        
        % check if Arg1 exists
        if rIndex_Fcn_i.Arg(j,1) ~= 0
            % add datahandle as input variable of the function
            % required, s.th. ctrlif works within the function
            
            % if Arg 1 exists connect 'datahandle' to Arg1 by nextnode
            [mtreeobj, rIndex_datahandle] = mtree_createAndAdd_NewNode(mtreeobj, ...
                rIndex_Fcn_i.Call(j), ...
                cIndex.indexRightchild, ...
                {mtreeobj.K.ID, config.datahandleArgumentName}, ...
                rIndex_Fcn_i.Arg(j,1), ...
                cIndex.indexNextNode);
        else
            % Arg1 does not exist, just add 'datahandle'
            [mtreeobj, rIndex_datahandle] = mtree_createAndAdd_NewNode(mtreeobj, ...
                rIndex_Fcn_i.Call(j), ...
                cIndex.indexRightchild, ...
                {mtreeobj.K.ID, config.datahandleArgumentName});
        end
        
        function_index_name_of_variable = [config.function_indexVariablePrefix, num2str(function_index)];
        
        % add function_indexX into function call
        [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
            rIndex_Fcn_i.Call(j), ...
            cIndex.indexRightchild, ...
            {mtreeobj.K.ID, function_index_name_of_variable}, ...
            rIndex_datahandle, ...
            cIndex.indexNextNode);
        
        % open new line above the function call
        [mtreeobj, rIndex_Fcn_i.newExprBeforeFcn] = mtree_addNewExprNode(mtreeobj, rIndex_Fcn_i.Expr(j));
        
        % equal node
        [mtreeobj, equal] = mtree_createAndAdd_NewNode(mtreeobj, ...
            rIndex_Fcn_i.newExprBeforeFcn, ...
            cIndex.indexLeftchild, ...
            mtreeobj.K.EQUALS);
        
        % call node for functtion updateFunctionIndex
        [mtreeobj, call] = mtree_createAndAdd_NewNode(mtreeobj, ...
            equal, ...
            cIndex.indexRightchild, ...
            mtreeobj.K.CALL);
        
        % add updateFunctionIndex
        [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
            call, ...
            cIndex.indexLeftchild, ...
            {mtreeobj.K.ID, config.updateFunctionIndex});
        
        [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
            equal, ...
            cIndex.indexLeftchild, ...
            {mtreeobj.K.ID, function_index_name_of_variable});
        
        
        % is_mtreeobj_rhs: true - > mtreeobj is rhs 
        % false -> mtreeobj is not rhs
        %
        % Arg1 of updateFunctionIndex. No 'old' function index in rhs is to be set
        if is_mtreeobj_rhs
            %rIndex.Fcn.(field_names{i}).Function_Index_Place_It_Here(j) = call; 
            
            [mtreeobj,Arg1] = mtree_createAndAdd_NewNode(mtreeobj, ...
                call, ...  % from
                cIndex.indexRightchild, ...                              % from_type
                {mtreeobj.K.INT, int2str(function_index)}); ...          % new node
            
            % set empty arg2 for function 'setFunctionIndex' in rhs. 
             [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
                Arg1, ...  % from
                cIndex.indexNextNode, ...                                                % from_type
                {mtreeobj.K.INT, '-1' });                             % new node
            
        else
            [mtreeobj, Arg1] = mtree_createAndAdd_NewNode(mtreeobj, ...
                call, ...
                cIndex.indexRightchild, ...
                {mtreeobj.K.ID, config.function_indexArgumentName});
            
            [mtreeobj, ~] = mtree_createAndAdd_NewNode(mtreeobj, ...
                Arg1, ...  % from
                cIndex.indexNextNode, ...                                                % from_type
                {mtreeobj.K.INT, int2str(function_index) });                             % new node

        end
        function_index = function_index + 1;
    end
end

end




























