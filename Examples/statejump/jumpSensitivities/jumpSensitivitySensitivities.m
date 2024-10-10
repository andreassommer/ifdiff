function [Gy1, Gp1, Uy1, Up1, Gy2, Gp2] = jumpSensitivitySensitivities(p, t0, x0, t1, x1Minus1, x1Plus1)
%JUMPSENSITIVITYSENSITIVITIES Get the intermediate G and U matrices for computing the sensitivities
% of jumpSensitivityRHS
    Gy1 = @(t) exp(p*(t-t0));
    Gp1 = @(t) (t-t0) * x0 * exp(p*(t-t0));
    Uy1 = 1/(4*p*x1Minus1^2);
    Up1 = 1/(4*p^3*x1Minus1^2) - 2/p^2;
    Gy2 = @(t) sqrt((t1 - t1 + x1Plus1^2) / (t + -t1 + x1Plus1^2));
    Gp2 = @(t) 0;
end