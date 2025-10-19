function dx = spiral_rhs(t, x, p)
    % ODE showing a spiral behavior, while every cross of an axis results
    % in a switch. In this way, the switching frequency goes to infinity.
    dx = zeros(2,1);

    dx(1) = -sign(x(1)) + 2*sign(x(2));
    dx(2) = -2*sign(x(1)) - sign(x(2));
end