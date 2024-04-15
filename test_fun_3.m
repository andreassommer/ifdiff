function dx = test_fun_3(t,x,p)

dx = zeros(2,1);
dx(1) = 0.01 * t.^2  +  x(2).^3;
if ~any(isnan(x))%IFDIFF:ignore
    if x(1) > p(1) 
        dx(1) = 3;
    else
        dx(1) = 0;
    end

    warning('Achtung')
else
    dx(1) = 10;
end

% if (x(2) > p(2)) % Klammern funktionieren nicht --> Fatal error 
%     dx(2) = 100;
% else
%     dx(2) = t.^2;
% end

end