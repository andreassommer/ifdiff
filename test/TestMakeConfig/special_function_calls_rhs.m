function dx = special_function_calls_rhs(t, x, p)
%SPECIAL_FUNCTION_CALLS_RHS A RHS function that contains if/abs/max/min/sign/helper-functions to test makeConfig.
%   Note that this function does not make any mathematical sense. It is merely meant to include
%   all syntactical structures that are treated in a special way by IFDIFFs preprocessing for testing purposes.


% Use a helper function, abs, sign, max, min and if.
% Call each at least twice to check proper numbering.
a = 1 * special_function_calls_helper(t, p);
a = 1 * special_function_calls_helper(t, p);

b = 1 * abs(t);
b = 1 * abs(t);
b = 1 * abs(t);

c = 1 * sign(t);
c = 1 * sign(t);

d = 1 * max(t, x);
d = 1 * max(t, x);

e = 1 * min(t, x);
e = 1 * min(t, x);

if x <= 5
    dx = a + b + c + d + e;
else
    dx = 0;
end
end