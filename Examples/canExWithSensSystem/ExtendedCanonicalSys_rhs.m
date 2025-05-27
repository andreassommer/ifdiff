% This is the extended canonical systems rhs, including the VDEs.
% The variables x_3 until x_6 are the entries of the x-Sensitivity
% The variables x_7 until x_8 are the entries of the p-Sensitivity

function dx = ExtendedCanonicalSys_rhs(t,x,p)
    dx = zeros(8,1);
    dx(1) = 0.01 * t.^2  +  x(2).^3;
    dx(3) = 3 * x(2).^2 * x(5);
    dx(4) = 3 * x(2).^2 * x(6);
    dx(5) = 0;
    dx(6) = 0;
    dx(7) = 3 * x(2).^2 * x(8);
    dx(8) = 0;
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