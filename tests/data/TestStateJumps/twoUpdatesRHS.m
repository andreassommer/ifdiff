function dx = twoUpdatesRHS(~, x, ~)
%TWOUPDATESRHS See if a state jump with two different calls to ifdiff_update in a single update block works
    dx = 1;
    if ifdiff_jumpif(mod(x, 5) - 3, 1)
        % when x first crosses 3, jump up to 5. The second time, it crosses 8, jump up to 11
        if x < 5
            ifdiff_update(2 + eps(2));
        else
            ifdiff_update(3);
        end
    end
end

