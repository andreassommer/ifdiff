function dx = expRHS(t, x, ~)
if t < 2
    dx = -x;
else
    dx = x;
end
end