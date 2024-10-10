function [t0, tEnd, p, x0] = jumpSensitivityInitdata()
%JUMPSENSITIVITYINITDATA Get time horizon, parameters, and initial value for jumpSensitivityRHS
    t0 = 0;
    tEnd = 10;
    p = 1/4;
    x0 = 1;
end