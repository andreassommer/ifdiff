function dx = testPreprocNestedHelperRHS(t,x,p)
%TESTPREPROCNESTEDHELPERRHS Variant of the issue example (same solution).
%   The logic is moved into a helper function file, which contains nested functions.
dx = testPreprocNestedHelper(t, x, p);
end
