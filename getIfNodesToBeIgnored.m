function comment_nodes_to_be_ignored = getIfNodesToBeIgnored(mtreeobj)
% SYNTAX: comment_nodes_to_be_ignored = getIfNodesToBeIgnored(mtreeobj)
% 
% Takes: mtreeobj
% Returns: Comment nodes which contain IFDIFF:ignore
%

    mtree_strings = mtreeobj.strings();
    commentnodes = mtree_mtfind(mtreeobj, 'Kind', mtreeobj.K.COMMENT);
    comments = mtree_strings(commentnodes);
    comments_ignore_index = checkString(comments) == 1;
    comment_nodes_to_be_ignored = commentnodes(comments_ignore_index);
    
end