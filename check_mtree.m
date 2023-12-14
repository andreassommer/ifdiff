function [m, flag, varargout] = check_mtree(filename)
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
        varargout = tree_strings; % Varargout kann auch andere Struktur sein, am besten postition bzw If node analysieren
    else
        flag = 0;
        m = mtreeplus(filename_complete, '-file');
    end



end