function [m, flag, index_if_tobeignored] = check_mtree(filename)
    %
    %
    %
    %
    %
    % Returns: mtree object with or without comments
    %
    filename_complete = strcat(filename, '.m');

    % Check for Comment IFDIFF:ignore
    tree_object = mtreeplus(filename_complete, '-file', '-comments');
    subtree_if = tree_object.mtfind('String', '% IFDIFF:ignore'); % ignore funktioniert nur fuer dises Kommentrastruktur
    if ~isempty(subtree_if)
        flag = 1;
        m = tree_object;
        indices_if_tobeignored = ;
    else
        flag = 0;
        m = mtreeplus(filename_complete, '-file');
        index_if_tobeignored = [];
    end



end