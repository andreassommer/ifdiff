function f = daeExampleRHS(t, x, p)
    
    global TimeLog
    global logEnabled

    if logEnabled % ifdiff::ignore
    TimeLog = [TimeLog, t];
    end

    %% RHS
    f = zeros(2,1);
    % algebraic constraint
    z = x(1) + x(2);
    f(2) = z;
    % differential variables
    if x(2) < p
        f(1) = x(2);
    else
        f(1) = 0;
    end
end
