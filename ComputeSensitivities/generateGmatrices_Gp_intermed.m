function Gp_new = generateGmatrices_Gp_intermed(datahandle, sol, Gmatrices_intermediate, amountG, modelNum, options)
   % Gp_new = generateGmatrices_Gp_intermed(datahandle, sol, Gmatrices_intermediate, amountG, modelNum, options)
   %
   % Calculates the intermediate G-matrices that contain the sensitivites w.r.t. p at the switching points
   % that define the model changes until modelNum.
   %
   % INPUT: datahandle             - datahandle you get from the integration process with solveODE
   %        sol                    - solution object from the integration with solveODE
   %        Gmatrices_intermediate - struct that contains the already calculated intermediates and updates w.r.t. y0 and p
   %        amountG                - amount of intermediate G-matrices that already have been calculated and saved from previous function calls.
   %                                 (If amountG = 1, it means that the intermediates were only initialised and all the matrices have still to be calculated.)
   %        modelNum               - number of the model until which the intermediates need to be calculated
   %        options                - struct that has the informations for the stepsizes for END, the integrator and the method
   %
   % OUTPUT: Gp_new - cell-array that contains the new calculated intermediates w.r.t. p
   
   % Initialize
   data = datahandle.getData();
   parameters = data.SWP_detection.parameters;
   switches = data.computeSensitivity.switches_extended;
   y_to_switches = data.computeSensitivity.y_to_switches;
   integrator = options.integrator;
   integrator_options = options.integrator_options;
   
   functionRHS = data.integratorSettings.preprocessed_rhs;
   functionRHS_simple_END = data.computeSensitivity.functionRHS_simple_END;
   functionRHS_simple_VDE = data.computeSensitivity.functionRHS_simple_VDE;
 
   dim_y = data.computeSensitivity.dim_y;
   dim_p = data.computeSensitivity.dim_p;
   unit_p = eye(dim_p);
   
   function_p_VDE = @(t,G) VDE_RHS_p(sol, functionRHS_simple_VDE, t, G, parameters, options);
   initial_p = reshape(zeros(dim_y,dim_p), [], 1);
   
   eval_disturb_p = zeros(dim_y, dim_p);
   Gp_intermediate = [Gmatrices_intermediate.Gp, cell(1, length(amountG : (modelNum-1)))];
   
   % Fix the model and set the model number for which model you want to evaluate the RHS
   data.caseCtrlif = 4;
   data.computeSensitivity.modelStage = amountG;
   datahandle.setData(data);
   
   % Set the step size for calculating finite differences. It can be either calculated relativ to the point where you are calculating
   % the derivative or it can be set to an absolute value. 
   FDstep = options.FDstep;
   if FDstep.p_rel
      point_p = abs(parameters);
      h_p = max(FDstep.p_min, point_p .* FDstep.p);
   else
      h_p = FDstep.p;
   end
   
   % Calculate the remaining intermediate G-matrices for the update formula until modelNum.
   % First the matrix Gp_ts2_ts1 need to be calculated. Here ts1 and ts2 stand for two consequtive switching points and the matrix contains
   % the sensitvities at the point ts2 with the starting time ts1. 
   for i = amountG : (modelNum - 1)
      tspan_end = switches(i+1);
      tspan_new = [switches(i), tspan_end];
      
      if options.method == options.methodCoded.END_piecewise
         % Calculate the G-matrix Gp_ts2_ts1 for the update formula using a simple integrator for solving ODEs (e.g. ode45)
         
         y_start = y_to_switches(:, i);
         sol_original = integrator(functionRHS_simple_END, tspan_new, y_start, integrator_options);
         y  = deval(sol_original,tspan_end);
         
         % Cycle through every parameter and compute the sensitivites
         for j=1:dim_p
            parameters_new = parameters + h_p.*unit_p(:,j);
            functionRHS_simple_disturb = @(t,y) functionRHS(datahandle, t, y,  parameters_new);
            sol_disturb = integrator(functionRHS_simple_disturb, tspan_new, y_start, integrator_options);
            eval_disturb_p(:,j) = deval(sol_disturb,tspan_end);
         end
         Gp_ts2_ts1 = (eval_disturb_p - y)./ reshape(h_p, 1, []);
         
      else
         % Calculate the G-matrix Gp_ts2_ts1 for the update formula using variational differential equations        
         solVDE = integrator(function_p_VDE, tspan_new, initial_p, integrator_options);
         Gp_ts2_ts1 = reshape(solVDE.y(:,end), dim_y, dim_p);
      end
      
      % Calculate the intermediate G-matrices according to the update formula
      if i == 1
         Gp_intermediate{i+1} = Gp_ts2_ts1;
      else
         Gp_intermediate{i+1} = Gmatrices_intermediate.Gy{i+1} * (Gmatrices_intermediate.Uy{i} * Gp_intermediate{i} + Gmatrices_intermediate.Up{i}) + Gp_ts2_ts1;
      end
      
      % if further calculations are necessary increase the model number in the datahandle
      if i < (modelNum-1)
         data = datahandle.getData();
         data.computeSensitivity.modelStage = data.computeSensitivity.modelStage + 1;
         datahandle.setData(data);
      end
   end
   
   Gp_new = Gp_intermediate;
end

