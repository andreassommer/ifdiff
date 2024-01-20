function out = checkString(cell_array)
    % SYNTAX: out = checkString(cell_array)
    %
    % Checks for Ifdiff comments to handly nodes differently
    % Supposed Input: String (string from Commentnode of mtreeobj)
    %
    % Input: Cell Array of form 1x variable length containing strings
    % Output: Doubles (1 = ignore, 2 = equals, 3 = filipopov, -1 = no Ifdiff prefix, -2 = Contains Ifdiff but no valid command)
    %
    %
    %
    len_cell = length(cell_array);
    out = zeros(1, len_cell);
    for i = 1:len_cell
        str = strrep(cell_array{i}, ' ', '');
        
        if contains(str, '%IFDIFF:') 
            str = strrep(str, '%IFDIFF', '');
            if contains(str, 'ignore')
                out(i) = 1;
            elseif contains(str, 'equals')
                out(i) = 2;
            elseif contains(str, 'filippov')
                out(i) = 3;
            else
                out(i) = -2; % Contains IFDIFF, but no  valid "command"
                return
            end
        else
            out(i) = -1; % str does not contain Ifdiff
        end
    end
end