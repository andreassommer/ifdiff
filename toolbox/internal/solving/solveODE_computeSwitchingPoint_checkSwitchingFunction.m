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
    throw(noSignChangeException(bisection.t1, bisection.t3));
end


% Open question:    What if bisection.sw1 == 0? Can we find an interval 
%                   where at the edges the switching function is nonzero,
%                   without provoking other issues?

end

%% Exceptions
function e = noSignChangeException(t1, t2)
msg = 'Unable to determine switching point: No sign change in switching function between t=%g and t=%g.\n';
e = MException('IFDIFF:Bisection:NoSignChange', msg, t1, t2);
end
