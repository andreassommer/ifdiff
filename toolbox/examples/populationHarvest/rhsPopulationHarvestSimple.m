function dy = rhsPopulationHarvest(~, y, p)
r = p(1);
K = p(2);
H = p(3);
alpha = p(4);

dy = r.*y .* (1 - y./K);
cond = y - H;
if ifdiff_jumpif(cond, 1)
    jump = -alpha .* y;
    ifdiff_update(jump);
end
end
