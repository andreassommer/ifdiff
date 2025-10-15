function dx = ignoreInHelperHelper(x)
%IGNOREINHELPERHELPER helper function with an ignored if statement (called from ignoreInHelperRHS)
    if x < 5 %ifdiff::ignore
        dx = 1;
    else
        dx = 2;
    end
end

