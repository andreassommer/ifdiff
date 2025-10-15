function dx = manyFunctions2(x)
%MANYFUNCTIONS2 second helper function for manyFunctions
    if x < 30
        dx = manyFunctions3(x);
    else
        dx = 0;
    end
end