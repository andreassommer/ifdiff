function dx = rhsStartInSwitchingPoint(~,x,p)
    dx = zeros(3,1);
    dx(1) = x(2);
    dx(2) = -x(1);

    if x(1) <= p
        if x(2) < 0
            dx(3) = -1;
        else
            dx(3) = 1;
        end
    end
end