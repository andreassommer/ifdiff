function areEqual = compareIfdiffSols(sol1, sol2)
%COMPAREIFDIFFSOLS Compare two augmented sol objects from IFDIFF integration on their final y values and switches
    relTol = ConfigProvider.getUserConfig().XEndTol();
    areEqual = true;
    if ~all(all(ismembertol(sol1.y(:, end), sol2.y(:, end), relTol)))
        areEqual = false;
    end
    if (size(sol1.switches) ~= size(sol2.switches))
        areEqual = false;
    end
    if ~all(all(ismembertol(sol1.switches, sol2.switches, relTol)))
        areEqual = false;
    end
end

