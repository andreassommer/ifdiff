function bisection = solveODE_computeSwitchingPoint_checkSwitchingFunction(bisection)
% Function that ensures that the following bisection algorithm can run
% without issues.
% In particular, it ensure that bisection.switchingFunction doesn't
% evaluate to zero at bisection.t1 and that it changes sign between
% bisection.t1 and bisection.t3.
%
% FUNCTION NEEDS REVISION.

% Sign change, everything is fine.
if sign(bisection.sw1) ~= sign(bisection.sw3)
    return
end

tolZero = 1e-10;
% Both interval points are far from zero, so inputs are bad, nothing we can do.
if abs(bisection.sw1) >= tolZero && abs(bisection.sw3) >= tolZero
    % TODO: Can we be certain that the switching function doesn't have an
    % even number of zero crossings instead? Should probably address this
    % case by recursively cutting the interval and try if we can find a
    % subinterval [t1, t3*] with different signs on the edges.
    throw(noSignChangeException(bisection.t1, bisection.t3));
end

% At least one of the interval points is close to zero.
% Might be able to create a zero crossing via small shift in switching function.
shift = 2 * min(abs(bisection.sw1), abs(bisection.sw3));
% If points positive shift down, else shift up.
if bisection.sw1 >= 0
    shift = -shift;
end
bisection.sw1 = bisection.sw1 + shift;
bisection.sw3 = bisection.sw3 + shift;
% Check sign change again after shift
if sign(bisection.sw1) == sign(bisection.sw3)
    throw(noSignChangeException(bisection.t1, bisection.t3));
end
bisection.switchingFunction = @(dh, t, x, p) bisection.switchingFunction(dh, t, x, p) + shift;
warnApplyingShift;

% Open question:    What if bisection.sw1 == 0? Can we find an interval
%                   where at the edges the switching function is nonzero,
%                   without provoking other issues?
end

%% Exceptions
function e = noSignChangeException(t1, t2)
msg = 'Unable to determine switching point: No sign change in switching function between t=%g and t=%g.\n';
e = MException('IFDIFF:Bisection:NoSignChange', msg, t1, t2);
end

%% Warnings
function warnApplyingShift
msg = [
    'Interval points for switching point computation have same sign, but close to zero.\n', ...
    'Applying small shift to switching function in an attempt to restore sign change.\n'];
warning('IFDIFF:Bisection:ApplyShift', msg);
end
