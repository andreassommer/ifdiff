function tf = mtree_ifnode_has_ifdiff_ignore(ifnode)
    % tf = mtree_ifnode_has_ifdiff_ignore(ifnode)
    %
    % For an if-statement checks whether it's followed by an
    % 'ifdiff:ignore' comment.
    % 
    % INPUT:
    %       'ifnode'      --> mtreeplus single-node subtree of kind 'IF'
    %
    % OUTPUT:
    %       'tf'        --> Flag (true/false) indicating whether the 
    %                       IF passed as (mtreeobj, index) pair has a
    %                       config.preprocess_ignorestring
    cIndex = mtree_cIndex();

    is_ifnode = (ifnode.T(ifnode.IX, cIndex.kindOfNode) == ifnode.K.IF);
    if ~is_ifnode
        error('Input node must be of type ''IF'', but is of type %s', kind(node));
    end

    first_body_node = Body(Arg(ifnode));
    first_body_node_is_comment = (...
        first_body_node.T(first_body_node.IX, cIndex.kindOfNode) == first_body_node.K.COMMENT);
    
    if first_body_node_is_comment
        % type is 'COMMENT'
        first_body_node_string = first_body_node.strings();
        tf = mtree_ifdiff_ignore_checkComment(first_body_node_string);
    else
        % type is not 'COMMENT'
        tf = false;
    end

end