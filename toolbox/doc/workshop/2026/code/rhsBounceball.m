function dy = rhsBounceball(t, y, p)
dy = [y(2); -9.81];

if ifdiff_jumpif(y(1), -1)
    jump = [0; -(1 + 0.9)*y(2)];
    ifdiff_update(jump);
end
end
