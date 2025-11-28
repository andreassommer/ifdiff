function extendODEuntilSwitch_t1_to_t2(datahandle)
% extend ode until t2
% t2 is in SWP_detection
% extends solution_until_t1 to t2

config = makeConfig();
data = datahandle.getData();

t = data.SWP_detection.solution_until_t1.x(end); 
x = deval(data.SWP_detection.solution_until_t1,  data.SWP_detection.solution_until_t1.x(end)); 

solution  = data.SWP_detection.solution_until_t1; 
end_point = data.SWP_detection.t2; 

% test with odeset
data.integratorSettings.options.InitialStep = 0.01; %% step formula
options   = data.integratorSettings.options; 
disp(options);

ctrlif_setForcedBranchingSignature(datahandle, t, x);
data = datahandle.getData();
data.caseCtrlif = config.caseCtrlif.extendODEuntilSwitch;
datahandle.setData(data);

z = odextend(solution, [], end_point, [], options);

data = datahandle.getData();
data.SWP_detection.solution_until_t2 = z;

datahandle.setData(data);
end



