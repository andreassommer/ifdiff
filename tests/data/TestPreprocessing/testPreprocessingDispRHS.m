function dy = testPreprocessingDispRHS(~, y, ~)
a = 10;
b = 20;
c = a + b;
d = -c; % should get removed in switching function
disp(a);
fprintf('%d%d%d\n', a, b, c);
% This will be removed, because we assume that a function with an output has no side effects.
nb = fprintf('%d%d%d\n', d, d, d);

dy = 1;
if y > 1
    dy = 0;
end
end
