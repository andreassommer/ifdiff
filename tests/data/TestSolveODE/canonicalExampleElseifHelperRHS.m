function dx = canonicalExampleElseifHelperRHS(t,x,p)
dx = zeros(2,1);
dx(1) = 0.01 * t.^2  +  x(2).^3;
dx = canonicalExampleElseifHelper(dx,t,x,p);
end
