function dx = ignoreInHelperRHS(~, x, ~)
%IGNOREINHELPERRHS RHS that calls a helper with an ignore directive
    dx = ignoreInHelperHelper(x);
    % since ifdiff refuses to preprocess RHSes that have no switches, we need an (unused) if statement
    if x > 1000
        dx = dx + 1;
    end
end

