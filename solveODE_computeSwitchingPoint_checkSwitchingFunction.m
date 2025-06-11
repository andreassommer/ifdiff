function bisection = solveODE_computeSwitchingPoint_checkSwitchingFunction(bisection)
% Function that ensures that the following bisection algorithm can run
% without issues.
% In particular, it ensure that bisection.switchingFunction doesn't
% evaluate to zero at bisection.t1 and that it changes sign between 
% bisection.t1 and bisection.t3.
%
% FUNCTION NEEDS REVISION.


if sign(bisection.sw1) == sign(bisection.sw3)
    % no switch has occurred
    % TODO: Can we be certain that the switching function doesn't have an
    % even number of zero crossings instead? Should probably address this
    % case by recursively cutting the interval and try if we can find a
    % subinterval [t1, t3*] with different signs on the edges.
    error([ 'The switch between t=', num2str(bisection.t1), ' and t=', num2str(bisection.t3), ...
            'could not be determined. The signature did not change.\n'])
end


if bisection.sw1 == 0
    % try to obtain a point left of t1 where the switching function is in
    % fact nonzero
    bisection = solveODE_computeSwitchingPoint_backtrackNonzero(bisection);
    % check whether switching function value of the model is zero at the initial value as well
end

end