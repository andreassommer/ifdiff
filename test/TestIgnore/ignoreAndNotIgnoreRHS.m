function dx = ignoreAndNotIgnoreRHS(~, x, ~)
%IGNOREANDNOTIGNORERHS a RHS that calls a helper function twice: once in a situation where it should be ignored,
% once in a situation where it cannot. Will IFDIFF correctly preprocess the second call, but not the first?
    if x < 5 %ifdiff::ignore
        dx = ignoreAndNotIgnore1(x, 1);
    else
        dx = ignoreAndNotIgnore1(x, 2);
    end
    dx = dx * ignoreAndNotIgnore1(0, 0);
end

