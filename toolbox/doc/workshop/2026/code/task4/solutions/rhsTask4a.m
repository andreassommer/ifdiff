function dy = rhsTask4a(~, y, p)
r = 2;
C = 1;

P = y(1);

dP = r.*P .* (1 - P./C);
dy = dP;
end
