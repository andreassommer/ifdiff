function dx = canonicalExampleElseifHelper(dx,t,x,p)
if x(1) < p(1)
    dx(2) = 0;
elseif x(1) < p(1) + 0.5
    dx(2) = 5;
else
    dx(2) = 0;
end
end
