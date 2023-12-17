function out = checkComment(str)
    % SYNTAX: out = checkComment(str)
    %
    % Checks for Ifdiff comments to handly nodes differently
    % Input: String (comment from node)
    % 
    % Output: True / false
    %
    % Anmerkung: Ist sehr langsam
    %

    out = false;
    if contains(str, 'IFDIFF:') 
        % TODO
        if contains(str, 'ignore')
            out = true;
        elseif contains(str, 'equals')
            out = true;
        elseif contains(str, 'filippov')
            out = true;
        else
            return
        end
    else
        return
    end
end