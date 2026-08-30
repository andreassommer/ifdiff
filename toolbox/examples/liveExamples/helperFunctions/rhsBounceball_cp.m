function dx = rhsBounceball_cp(~, x, p)
    dx = [x(2); -p(1)];
    if ifdiff_jumpif(x(1), -1)
        deltaH = -x(1) + eps(1)*(1/p(1)) * p(2)^2*x(2)^2;
        deltaV = -(1+p(2))*x(2);
        ifdiff_update([deltaH; deltaV]);
    end
end