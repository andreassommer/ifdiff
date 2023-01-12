function bisection = solveODE_computeSwitchingPoint_checkSwitchingFunction(bisection)
% function that checks whether the switching function makes sense and
% delivers a well defined switching point w.r.t to the capability of the
% programm.
problemDetected = false; 
% can be extended if necessary
if sign(bisection.sw1) == sign(bisection.sw3)
    % no switch has occured
    problemDetected = true;
end

% default 
bisection.sw1_isNotZero = 1;
if bisection.sw1 == 0
    % check whether switching function value of the model is zero at the initial value as well
    
    sw0 = bisection.switchingFunction([], bisection.t0, bisection.y0, bisection.p);
    
    if sw0 == 0
        bisection.sw1_isNotZero = 0;
    else
        problemDetected = true;
    end
end

if problemDetected == true
    error(['There is a problem, with the switch between ', num2str(bisection.t1), ' and ', num2str(bisection.t3),'.', ...
        'The switch will not be able to be determined'])
end

end