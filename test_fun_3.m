function dx = test_fun_3(t,x,p)


if any(isnan(x))
    warning('Achtung')
end


dx = zeros(2,1);
dx(1) = 0.01 * t.^2  +  x(2).^3;

if x(1) > p(1)
    dx(1) = 3;
else
    dx(1) = 0;
end



if x(2) > p(2) % IFDIFF:ignore
    dx(2) = 100;
else
    dx(2) = t.^2;
end

end