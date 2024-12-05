function delta = helperInJump1(x)
    if x(2) < 3
        delta = [-x(1); 0];
    else
        delta = [x(1); 0];
    end
end

