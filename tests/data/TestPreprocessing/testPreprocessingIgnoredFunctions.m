function dy = testPreprocessingIgnoredFunctions(~, y, ~)
a = 10;
b = 20;
c = a + b;
d = -c;

% Should be kept, because disp/fprintf in ignore list
disp(a);
fprintf('%d%d%d\n', a, b, c);
nb = fprintf('%d%d%d\n', d, d, d);

% Should be removed because not part of ignore list
e = 3;
sin(e);

% User defined ignored function should not be preprocessed and simply kept
f = 5*y;
testPreprocessingIgnoredFunctionsHelper(f);

dy = 1;
if y > 1
    dy = 0;
end
end
