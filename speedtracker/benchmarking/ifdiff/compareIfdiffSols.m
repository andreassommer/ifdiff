function areEqual = compareIfdiffSols(sol1, sol2)
%COMPAREIFDIFFSOLS Compare two augmented sol objects from IFDIFF integration on their final y values and switches
    relTol = ConfigProvider.getUserConfig().YEndTol();
    areEqual = true;
    y1End = sol1.y(:, end);
    y2End = sol2.y(:, end);
    yEndWithinTol = abs(y1End - y2End) <= relTol * max(abs([y1End(:); y2End(:)]));
    % compare solution at tEnd
    if ~all(yEndWithinTol(:))
        areEqual = false;
    end
    if (size(sol1.switches) ~= size(sol2.switches))
        areEqual = false;
    end
    switchesTol = relTol * max(abs([sol1.switches(:); sol2.switches(:)]));
    switchesWithinTol = abs(sol1.switches - sol2.switches) <= switchesTol;
    if ~all(switchesWithinTol(:))
        areEqual = false;
    end
end

