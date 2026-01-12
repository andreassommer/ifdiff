function extendODEuntilSwitch_t1_to_t2(datahandle)
% extend ode until t2
% t2 is in SWP_detection
% extends solution_until_t1 to t2

config = makeConfig();
data = datahandle.getData();

% last integrator step before switch
ti = data.SWP_detection.solution_until_t1.x(end); 

% solution at the last time point before switch
x = deval(data.SWP_detection.solution_until_t1, ti); 

solution  = data.SWP_detection.solution_until_t1; 
end_point = data.SWP_detection.t2; 
delta_t = end_point - ti;

options   = data.integratorSettings.options;

solver = solution.solver;
switch solver
    case {'ode23', 'ode45', 'ode78', 'ode89', 'ode113', 'ode23t', 'ode23tb'}

        data.integratorSettings.options.InitialStep = delta_t;
        data.integratorSettings.options.AbsTol = 1;
        data.integratorSettings.options.RelTol = 1;
       
        ctrlif_setForcedBranchingSignature(datahandle, ti, x);
        data = datahandle.getData();
        data.caseCtrlif = config.caseCtrlif.extendODEuntilSwitch;
        datahandle.setData(data);
        
        z = odextend(solution, [], end_point, [], options);
        
        data = datahandle.getData();
        data.SWP_detection.solution_until_t2 = z;
    case {'ode15s'}
        ctrlif_setForcedBranchingSignature(datahandle, ti, x);
        data = datahandle.getData();
        data.caseCtrlif = config.caseCtrlif.extendODEuntilSwitch;
        datahandle.setData(data);
        
        z = odextend(solution, [], end_point, [], options);
        
        data = datahandle.getData();
        data.SWP_detection.solution_until_t2 = z;
    otherwise
        error('The solver is not known to the programm - can not continue.');
end

datahandle.setData(data);
end



