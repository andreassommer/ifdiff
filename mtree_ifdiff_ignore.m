function tf = mtree_ifdiff_ignore(mtreeobj, index)
    % tf = mtree_ifdiff_ignore(mtreeobj, index)
    %
    % For an if-statement whether it's followed by an "ifdiff:ignore" 
    % comment. 
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

    % get the subtree at the input node, and from that tree all *body* nodes
    mtreeobj_if = Full(select(mtreeobj,index));
    body_nodes = Body(mtreeobj_if);
    body_nodes_indices = body_nodes.indices();
    
    % we want to check if the first *body* node of the if-statement is an
    % ifdiff ignore comment
    first_body_node = select(mtreeobj, body_nodes_indices(1));
    first_body_node_type = first_body_node.kinds();
    first_body_node_string = first_body_node.strings();

    if strcmp(first_body_node_type, 'COMMENT')
        % type is 'COMMENT'
        tf = mtree_ifdiff_ignore_checkComment(first_body_node_string);
    else
        % type is not 'COMMENT'
        tf = false;
    end

end