function generateData(datahandle, sol)
   % generateData(datahandle)
   %
   % Generates the data that is needed in many of the functions used for the sensitivity calculation 
   % that is not changed over the time of the calculation. 
   %
   % INPUT: datahandle - datahandle you get from the integration process with solveODE
   %        sol        - solution object from the integration with solveODE
   %
   % OUTPUT: None (The data is written into the datahandle)
   
   data = datahandle.getData();
   data.SWP_detection.parameters = reshape(data.SWP_detection.parameters, [], 1);
 
   % to use the integrator (e.g. ode45, not solveODE) for the calculation of the intermediate G-matrices we need the RHS function
   % as a function only from t and y using the fixed model (fixed in the datahandle)
   data.computeSensitivity.functionRHS_simple_END = @(t,y) data.integratorSettings.preprocessed_rhs(datahandle, t, y,  data.SWP_detection.parameters);
   data.computeSensitivity.functionRHS_simple_VDE = @(t, y, parameters) data.integratorSettings.preprocessed_rhs(datahandle, t, y,  parameters);

   data.computeSensitivity.switches_extended = [data.SWP_detection.tspan(1), sol.switches, data.SWP_detection.tspan(end)];
   data.computeSensitivity.y_to_switches = deval(sol, data.computeSensitivity.switches_extended);
   
   data.computeSensitivity.dim_y = size(sol.y, 1);
   data.computeSensitivity.dim_p = length(data.SWP_detection.parameters);
   
   datahandle.setData(data);
end