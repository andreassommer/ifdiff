function dx = simpleIgnoreRHS(t, x, p)
%SIMPLEIGNORERHS A RHS containing an ignored if statement for testing
% Integrate from 0 to 10 with x0=0;
    if x < 5 %ifdiff::ignore
        dx = 1;
    else
        dx = 2;
    end
    % since ifdiff refuses to preprocess RHSes that have no switches, we need an (unused) if statement
    if x > 1000
        dx = dx + 1;
    end
end

