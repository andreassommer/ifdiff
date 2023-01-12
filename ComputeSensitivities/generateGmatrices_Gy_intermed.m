function Gy_new = generateGmatrices_Gy_intermed(datahandle, sol, amountG, modelNum, options)
   % Gy_new = generateGmatrices_Gy_intermed(datahandle, sol, amountG, modelNum, options)
   %
   % Calculates the intermediate G-matrices that contain the sensitivites w.r.t. y0 at the switching points
   % that define the model changes until modelNum.
   %
   % INPUT: datahandle - datahandle you get from the integration process with solveODE
   %        sol        - solution object from the integration with solveODE
   %        amountG    - amount of intermediate G-matrices that already have been calculated and saved from previous function calls.
   %                     (If amountG = 1, it means that the intermediates were only initialised and all the matrices have still to be calculated.)
   %        modelNum   - number of the model until which the intermediates need to be calculated
   %        options    - struct that has the informations for the stepsizes for END, the integrator and the method
   %
   % OUTPUT: Gy_new - cell-array that contains the new calculated intermediates w.r.t. y
   
   % Initialize
   data = datahandle.getData();
   parameters = data.SWP_detection.parameters;
   switches = data.computeSensitivity.switches_extended;
   y_to_switches = data.computeSensitivity.y_to_switches;
   integrator = options.integrator;
   integrator_options = options.integrator_options;
   FDstep = options.FDstep;
   
   functionRHS_simple_END = data.computeSensitivity.functionRHS_simple_END;
   functionRHS_simple_VDE = data.computeSensitivity.functionRHS_simple_VDE;

   dim_y = data.computeSensitivity.dim_y;
   unit_y = eye(dim_y);
  
   initial_y = reshape(unit_y, [], 1);
   function_y_VDE = @(t,G) VDE_RHS_y(sol, functionRHS_simple_VDE, t, G, parameters, options);
   
   amount_new_matrices = (modelNum-1) - (amountG - 1);
   Gy_new = cell(1, amount_new_matrices);
   eval_disturb_y0 = zeros(dim_y);

   % Fix the model and set the model number for which model you want to evaluate the RHS
   data.caseCtrlif = 4;
   data.computeSensitivity.modelStage = amountG;
   datahandle.setData(data);
   
   % Calculate the remaining intermediate G-matrices for the update formula until modelNum.
   % Here ts1 and ts2 stand for two consequtive switching points and the matrix Gy_ts2_ts1 contains
   % the sensitvities at the point ts2 with the starting time ts1. 
   save = 1;
   for i = amountG : (modelNum-1)
      tspan_end = switches(i+1);
      tspan_new = [switches(i), tspan_end];
      
      if options.method == options.methodCoded.END_piecewise
         % Calculate the G-matrix Gy_ts2_ts1 for the update formula using a simple integrator for solving ODEs (e.g. ode45)
         
         y_start = y_to_switches(:, i);
         sol_original = integrator(functionRHS_simple_END, tspan_new, y_start, integrator_options);
         y  = deval(sol_original,tspan_end);
         
         % Set the step size for calculating finite differences. It can be either calculated relativ to the point where you are calculating
         % the derivative or it can be set to an absolute value.
         if FDstep.y_rel
            point_y = abs(y_start);
            h_y = max(FDstep.y_min, point_y .* FDstep.y);
         else
            h_y = FDstep.y;
         end
         
         % Cycle through every initial value and compute the sensitivites
         for j=1:dim_y
            sol_disturb = integrator(functionRHS_simple_END, tspan_new, y_start + h_y.*unit_y(:,j), integrator_options);
            eval_disturb_y0(:,j) = deval(sol_disturb,tspan_end);
         end 
         Gy_ts2_ts1 = (eval_disturb_y0 - y)./ reshape(h_y, 1, []);
         
      else
         % Calculate the G-matrix Gy_ts2_ts1 for the update formula using variational differential equations    
         solVDE = integrator(function_y_VDE, tspan_new, initial_y, integrator_options);
         Gy_ts2_ts1 = reshape(solVDE.y(:,end), dim_y, dim_y);
      end
      
      Gy_new{save} = Gy_ts2_ts1;
      save = save + 1;
      
      % if further calculations are necessary increase the model number in the datahandle
      if i < (modelNum-1)
         data = datahandle.getData();
         data.computeSensitivity.modelStage = data.computeSensitivity.modelStage + 1;
         datahandle.setData(data);
      end
   end
end