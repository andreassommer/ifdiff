function dy = statementAfterReturn(t, y, p)
    [z, myCondition] = multiReturn(y, t);
    if myCondition < 8
        dy = z;
    else
        dy = y / 2;
    end
end

