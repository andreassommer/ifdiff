function dx = manyFunctions(~, x, ~)
%MANYFUNCTIONS Complicated RHS combining various ways in which helper functions can appear: inside an if condition,
% inside an if body, and inside another helper function. The solution is (hopefully) a function that climbs linearly
% with slope 1 until 10, 2 until 20, 1 until 30, and finally 0.
    if manyFunctions1(x) < 10
        dx = 1;
    else
        dx = manyFunctions2(x);
    end
end