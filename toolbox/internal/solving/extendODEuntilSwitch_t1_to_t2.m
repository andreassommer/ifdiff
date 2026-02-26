function extendODEuntilSwitch_t1_to_t2(datahandle)
% extend ode until t2
% t2 is in SWP_detection
% extends solution_until_t1 to t2

config = makeConfig();
data = datahandle.getData();

solution  = data.SWP_detection.solution_until_t1;
ti        = solution.x(end);    % last integrator step before switch
x         = solution.y(:, end); % solution at the last time point before switch
end_point = data.SWP_detection.t2;
options   = data.integratorSettings.options;

% Setup forced branching signature.
ctrlif_setForcedBranchingSignature(datahandle, ti, x);
data = datahandle.getData();
data.caseCtrlif = config.caseCtrlif.extendODEuntilSwitch;
datahandle.setData(data);

% Modified options for one step solvers to reach end point in one step.
if config.last_point_strategy.is_active(solution.solver)
    % Since the one step solver accepted the larger step t3 > t2, a smaller step to t2 should also be accepted.
    options = data.integratorSettings.options;
    options.MaxStep = inf;
    options.InitialStep = inf;
end

data.SWP_detection.solution_until_t2 = odextend(solution, [], end_point, [], options);
datahandle.setData(data);
end
