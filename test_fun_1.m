function dx = test_fun_1(t,x,p)

dx = zeros(2,1);
dx(1) = 0.01 * t.^2  +  x(2).^3;
% Testkommentar 1
if x(1) < p(1) 
    dx(2) = 0;
else
    if x(1) < p(1) + 0.5 % IFDIFF:ignore
        dx(2) = 5;
        
    else
        dx(2) = 0;
    end
end


end



