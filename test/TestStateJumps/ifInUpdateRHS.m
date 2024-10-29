function dx = ifInUpdateRHS(t, x, p)
%IFINUPDATERHS has a jump with nondifferentiabilities inside the update block. These should be ignored
% and the update block just pasted into the update function.
    dx = -1;
    if ifdiff_jumpif(x(1) + 10, -1)
        if x(1) < -100
            ifdiff_update(-100);
        else
            ifdiff_update(abs(x(1)) / 2);
        end
    end
end

