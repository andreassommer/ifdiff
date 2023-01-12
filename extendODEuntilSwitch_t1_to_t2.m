function extendODEuntilSwitch_t1_to_t2(datahandle)
% extend ode until t2
% t2 is in SWP_detection
% extends solution_until_t1 to t2

data = datahandle.getData();

t = data.SWP_detection.solution_until_t1.x(end); 
x = deval(data.SWP_detection.solution_until_t1,  data.SWP_detection.solution_until_t1.x(end)); 


solution  = data.SWP_detection.solution_until_t1; 
end_point = data.SWP_detection.t2; 
options   = data.integratorSettings.options; 

ctrlif_setForcedBranchingSignature(datahandle, t, x);
data.caseCtrlif = 2; % case forced branching
datahandle.setData(data);

z = odextend(solution, [], end_point, [], options);

data = datahandle.getData();
data.SWP_detection.solution_until_t2 = z;


datahandle.setData(data);

% get Signature of rhs at t2
extendODEuntilSwitch_updateSignature_t2(datahandle);


end



