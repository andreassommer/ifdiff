function dx = swbRHS_jump(~,x,p)
    dx = zeros(3,1);
    dx(1) = x(2); % sinus
    dx(2) = -x(1); % cosinus

    if ifdiff_jumpif(x(1) - p, 0)
            if x(2) < 0
                ifdiff_update(d(x) - 1)
                dx(3) = -1;
            else
                dx(3) = 1;
            end
    end

end