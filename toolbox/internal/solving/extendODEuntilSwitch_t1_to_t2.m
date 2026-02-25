function extendODEuntilSwitch_t1_to_t2(datahandle)
% extend ode until t2
% t2 is in SWP_detection
% extends solution_until_t1 to t2

config = makeConfig();
data = datahandle.getData();

solution  = data.SWP_detection.solution_until_t1;
ti        = solution.x(end);    % last integrator step before switch
x         = solution.y(:, end); % solution at the last time point before switch
 
solver    = solution.solver;
options   = data.integratorSettings.options;
end_point = data.SWP_detection.t2;

ctrlif_setForcedBranchingSignature(datahandle, ti, x);
data = datahandle.getData();
data.caseCtrlif = config.caseCtrlif.extendODEuntilSwitch;
datahandle.setData(data);

if config.last_point_strategy.is_active(solver) % last point strategy for one step solvers
 
    % new step size
    delta_t = end_point - ti;

    data.integratorSettings.options.InitialStep = delta_t;
    data.integratorSettings.options.AbsTol = 1;
    data.integratorSettings.options.RelTol = 1;

    z = odextend(solution, [], end_point, [], options);
    data = datahandle.getData();
    data.SWP_detection.solution_until_t2 = z;
else
    z = odextend(solution, [], end_point, [], options);
    data.SWP_detection.solution_until_t2 = z;
end

datahandle.setData(data);
end
