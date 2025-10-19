function dx = canonicalExampleRHS(t,x,p)

dx = zeros(2,1);
dx(1) = 0.01 * t.^2  +  x(2).^3;

if x(1) < p(1) 
    dx(2) = 0;
else
    if x(1) < p(1) + 0.5
        dx(2) = 5;
    else
        dx(2) = 0;
    end
end

end



