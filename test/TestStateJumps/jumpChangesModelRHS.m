function dx = jumpChangesModelRHS(~, x, p)
%JUMPCHANGESMODELRHS an RHS where the jump causes another model change between t2- and t2+. IFDIFF should
% just take this in stride and resume integration with the new model
    dx = zeros(2, 1);
    dx(1) = x(2);
    if x(1) < 4
        dx(2) = p(1);
    else
        if x(1) < 12
            dx(2) = 0;
        else
            dx(2) = -p(1);
        end
    end
    ifdiff_jumpif(x(1)-4, 1, [9; 0]);
end

