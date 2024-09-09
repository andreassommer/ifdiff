function tf = mtree_ifdiff_ignore_checkComment(comment_string)
    % tf = mtree_ifdiff_ignore(comment_string)
    %
    % Checks if 'comment_string' contains the ignorestring defined in the
    % config struct.
    % 
    % INPUT:
    %       'comment_string'    --> Character array or string to be checked.
    %
    % OUTPUT:
    %       'tf'                --> Flag (true/false) indicating whether
    %                               'comment_string' contains the ignorestring.
    %

    config = makeConfig();
    ignorestring = config.preprocess_ignorestring;
    
    comment_string = lower(comment_string);
    tf = contains(comment_string, ignorestring);

end