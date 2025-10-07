function cond = analyseSignature_checkForSwitch(cond1, cond2)


if isempty(cond1)
    cond = false;
    return
end

if isempty(cond2)
    cond = false;
    return
end


if length(cond1) ~= length(cond2)
    cond = true;
else
    condMatches = cond1 ~= cond2;
    cond = any(condMatches(:));
end





end
