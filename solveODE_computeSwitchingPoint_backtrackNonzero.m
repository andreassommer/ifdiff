function bisection = solveODE_computeSwitchingPoint_backtrackNonzero(bisection)
% bisection = solveODE_computeSwitchingPoint_backtrackNonzero(bisection)
% Searches for a timepoint smaller bisection.t1 where 
% biscetion.switchingFunction is nonzero.
% 
%
% INPUT:
%   'bisection':    structure containing variables related to the bisection
%                   search of a switching point, such as left, right, and
%                   middle timepoints and corresponding function values.
%                       struct
%
% OUTUPT:
%   'bisection'     Changed bisection structure.
%                       struct


t1 = bisection.t1;
sw1 = bisection.sw1;
step = eps(t1);

while sw1 == 0
    t1  = t1-step;
    y1  = deval(bisection.solution, t1);
    sw1 = bisection.switchingFunction([], t1, y1, bisection.p);
    
    % prepare next iteration
    step = 2*step;
    if t1 < bisection.solution.x(end-2)
        % probably don't want to go back further than one integrator step.
        % this shouldn't every really happen unless we have a poorly
        % behaved switch! --> i.e., no consistent switch from one to the
        % other model/signature
        error(  'IFDIFF:ComputeSwitchingPointFailed', ...
                ['Switching point in between t=', num2str(bisection.t1), ' and t=', num2str(bisection.t3), ...
                'could not be computed.\n No nonzero point of the switching function could be found.\n']);
    end
end

bisection.t1    = t1;
bisection.y1    = y1;
bisection.sw1   = sw1;



end