function dy = rhsPopulationHarvest(~, y, p)
P = y(1);
r = p(1);
C = p(2);
T = p(3);
alpha = p(4);

dP = r.*P .* (1 - P./C);
dH = 0;
dy = [dP; dH];

cond = P - T;
if ifdiff_jumpif(cond, 1)
    harvest = alpha .* P;
    jump = [-harvest; harvest];
    ifdiff_update(jump);
end
end
