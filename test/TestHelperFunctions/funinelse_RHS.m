function dx = funinelse_RHS(~, x, ~)
%FUNINELSE_RHS demonstrating a bug if a function call is in an else block
    if x < 10
        dx = 1;
    else
        dx = funinelse_ext(x);
    end
end

