function dx = canNestSepFuncFileRHSouter(t, x, p)
% Test 3 of the canonical example with parts as nested functions
% here separate matlab function file for nested function
dx = canNestSepFuncFileRHSinner(t, x, p);
end