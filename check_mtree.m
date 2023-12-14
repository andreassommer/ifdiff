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
    tree_strings = strings(tree_object);
    if any(strcmp(tree_strings, '% IFDIFF:ignore')) % Kommentar muss exakt diese Form haben mit Leerzeichen
        flag = 1;
        m = tree_object;
        index_if_tobeignored = [];
    else
        flag = 0;
        m = mtreeplus(filename_complete, '-file');
        index_if_tobeignored = [];
    end



end