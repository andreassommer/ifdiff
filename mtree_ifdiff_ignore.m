function tf = mtree_ifdiff_ignore(mtreeobj, index)
    % tf = mtree_ifdiff_ignore(mtreeobj, index)
    %
    % For an if-statement checks whether it's followed by a
    % comment containing the ignorestring (specified in
    % config.preprocess_ignorestring) or is
    % enclosed by another if-statemtn that has the ignorestring.
    % In that case, the if-statement should be ignored by the
    % preprocessing, i.e., not transformed into a ctrlif.
    % 
    % INPUT:
    %       'mtreeobj'  --> mtreeplus object
    %       'index'     --> index of an IF-node in mtreeobj
    %
    % OUTPUT:
    %       'tf'        --> Flag (true/false) indicating whether the 
    %                       IF passed as (mtreeobj, index) pair should be 
    %                       ignored by preprocessing.
    %
    % Note: A tuple (mtreeobj, index) specifies one node in the mtree given
    % by mtreeobj (or several if 'index' is an array). We refer to it as
    % the input node here.


    % climb up the tree while checking every if statement for an ifdiff_ignore
    cIndex = mtree_cIndex();

    tf = false;
    node = select(mtreeobj, index);

    fct_id = node.K.FUNCTION;
    if_id = node.K.IF;
    node_type_id = node.T(node.IX, cIndex.kindOfNode);

    while ~(node_type_id==fct_id) && ~tf
        % stop when reached 'FUNCTION' node (root) 
        % or an if has the ignorestring

        if node_type_id == if_id
            tf = mtree_ifnode_has_ifdiff_ignore(node);
        end

        node = trueparent(node);
        node_type_id = node.T(node.IX, cIndex.kindOfNode);
    end


end