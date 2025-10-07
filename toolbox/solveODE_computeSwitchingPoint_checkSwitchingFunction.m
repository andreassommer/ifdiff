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


% Open question:    What if bisection.sw1 == 0? Can we find an interval 
%                   where at the edges the switching function is nonzero,
%                   without provoking other issues?

end