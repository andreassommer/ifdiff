function dy = rhsTask4b(~, y, p)
r = 2;
C = 1;

T     = p(1);
alpha = p(2);
P = y(1);

dP = r.*P .* (1 - P./C);
dH = 0;
dy = [dP; dH];

harvestCondition = P - T;
if ifdiff_jumpif(harvestCondition, 1)
    harvest = alpha .* P;
    jump = [-harvest; harvest];
    ifdiff_update(jump);
end
end
