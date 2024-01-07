function out = checkComment(cell_array)
    % SYNTAX: out = checkComment(str)
    %
    % Checks for Ifdiff comments to handly nodes differently
    % Input: String (comment from node)
    % Input: Cell Array of form 1x variable length
    % Output: True / false
    %
    % Anmerkung: Ist sehr langsam, geht nicht wenn IFDIFF : oder aehnlich
    %
    len_cell = length(cell_array);
    out = zeros(1, len_cell);
    for i = 1:len_cell
        str = cell_array{i};
        if contains(str, '% IFDIFF:') 
            if contains(str, 'ignore')
                out(i) = 1;
            elseif contains(str, 'equals')
                out(i) = 2;
            elseif contains(str, 'filippov')
                out(i) = 3;
            else
                out(i) = -2;
                return
            end
        else
            out(i) = -1;
        end
    end
end