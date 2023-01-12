function [mtreeobj, new_index] = preprocess_setUpCtrlif_addArgument(mtreeobj, index, value, by)


if ischar(value)
        [mtreeobj, new_index] = mtree_createAndAdd_NewNode(mtreeobj,...
            index, ...                                   % from
            by, ...                   % from_type
            {mtreeobj.K.ID, value});                 % kind of node, string
else 
    mtreeobj = mtree_connectNodes(mtreeobj, index, value, by);
    new_index = value;
end

end