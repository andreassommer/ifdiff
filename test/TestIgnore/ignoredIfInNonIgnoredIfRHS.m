function dx = ignoredIfInNonIgnoredIfRHS(~, x, ~)
%IGNOREDIFINNONIGNOREDIFRHS RHS with an ignored if inside a non-ignored if
% Integrate from 0 to 10
    if x < 5
        dx = 1;
    else
        if x < 7  %ifdiff::ignore
            dx = 2;
        else
            dx = 3;
        end
    end
end

