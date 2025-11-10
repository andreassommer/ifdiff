function flag = compareSignatures(ctrlif_index1, ctrlif_index2, function_index1, function_index2, switch_cond1, switch_cond2)
% flag = compareSignatures(ctrlif_index1, ctrlif_index2, function_index1, function_index2, switch_cond1, switch_cond2)
% 
% Compares two signatures. Returns true if they are equal, false if not.

flag = true;

if ~all(switch_cond1 == switch_cond2) || ~all(ctrlif_index1 == ctrlif_index2)
    flag = false;
    return
end

if length(function_index1) ~= length(function_index2)
    flag = false;
    return
else
    for i=1:length(function_index1)
        if ~all(function_index1{i}==function_index2{i})
            flag = false;
            break
        end
    end
end

end