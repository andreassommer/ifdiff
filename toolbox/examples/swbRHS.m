function dx = swbRHS(~,x,p)
    dx = zeros(3,1);
    dx(1) = x(2);
    dx(2) = -x(1);

    % egal wie kurz man geht, ist bei p=0 immer Schalter
    if x(1) <= -p
        if x(1) <= p
            dx(3) = sign(x(2));
        end
    end
end
