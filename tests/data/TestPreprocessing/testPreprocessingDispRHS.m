function dy = testPreprocessingDispRHS(~, y, ~)
a = 10;
b = 20;
c = a + b;
d = -c;
% Should be kept, because disp/fprintf in whitelist
disp(a);
fprintf('%d%d%d\n', a, b, c);
nb = fprintf('%d%d%d\n', d, d, d);

% Should be removed because not part of whitelist
e = 3;
sin(e);

dy = 1;
if y > 1
    dy = 0;
end
end
