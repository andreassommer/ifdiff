function dx = nestedIgnoreRHS(~, x, ~)
%NESTEDIGNORERHS A RHS containing nested, ignored if statements
% Integrate from 0 to 10
    if x < 5 %ifdiff::ignore
        dx = 1;
    else
        if x < 7
            dx = 2;
        else
            dx = 3;
        end
    end
    % since ifdiff refuses to preprocess RHSes that have no switches, we need an (unused) if statement
    if x > 1000
        dx = dx + 1;
    end
end

