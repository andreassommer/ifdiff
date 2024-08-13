function Updates = generateGmatrices_Updates(datahandle, amountG, modelNum, Gp_flag, options)
   % Updates = generateGmatrices_Updates(datahandle, amountG, modelNum, Gp_flag, options)
   %
   % Calculates the update-matrices for the sensitivitiy calculation with END_piecewise or VDE.
   %
   % INPUT: datahandle - datahandle you get from the integration process with solveODE
   %        amountG    - amount of intermediate G-matrices that already have been calculated and saved from previous function calls.
   %                     (If amountG = 1, it means that the intermediates were only initialised and all the matrices have still to be calculated.)
   %        modelNum   - number of the model until which the update-matrices need to be calculated
   %        Gp_flag    - flag that is true if the sensitivities with respect to the parameters should be calculated
   %        options    - struct that has the informations for the stepsizes for END, the integrator and the method
   %
   % OUTPUT: Updates - struct that has he update-matrices needed for the sensitivities w.r.t. y0 and optionally w.r.t. p
   
   % Initialize
   data = datahandle.getData();
   parameters = data.SWP_detection.parameters;
   switches = data.computeSensitivity.switches_extended;
   y_to_switches = data.computeSensitivity.y_to_switches;
   switching_functions = data.SWP_detection.switchingFunction;
   functionRHS =  data.integratorSettings.preprocessed_rhs;
   
   FDstep = options.FDstep;
   
   dim_y = data.computeSensitivity.dim_y;
   unit = eye(dim_y);
   
   amount_new_matrices = (modelNum - 1) - (amountG - 1);
   Updates.Uy_new = cell(1, amount_new_matrices);
 
   if Gp_flag
      Updates.Up_new = cell(1, amount_new_matrices);
      
      % Set the step size for calculating finite differences. It can be either calculated relativ to the point where you are calculating
      % the derivative or it can be set to an absolute value.
      if FDstep.p_rel
         point_p = abs(parameters);
         h_p = max(FDstep.p_min, point_p .* FDstep.p);
      else
         h_p = FDstep.p;
      end
   end

   % Fix the model and set the model number for which model you want to evaluate the RHS
   data.computeSensitivity.modelStage = amountG;
   datahandle.setData(data);
   
   % Calculate the remaining update matrices for the update formula until modelNum.
   save = 1;
   for i = amountG : (modelNum-1)
      switchingFunction = switching_functions{i};
      y_to_switch = y_to_switches(:, i+1);
      switchingPoint = switches(i+1);
      
      % Set the step size for calculating finite differences. It can be either calculated relativ to the point where you are calculating
      % the derivative or it can be set to an absolute value.
      if FDstep.y_rel
         point_y = abs(y_to_switch);
         h_y = max(FDstep.y_min, point_y .* FDstep.y);
      else
         h_y = FDstep.y;
      end
      
      if FDstep.t_rel
         point_t = abs(switchingPoint);
         h_t = max(FDstep.t_min, point_t .* FDstep.t);
      else
         h_t = FDstep.t;
      end
      
      % Calculate the derivatives of the switching functions w.r.t. y, t (and p if necessary)
      diff_sigmay = diff_sigma_y(datahandle, switchingFunction, switchingPoint, y_to_switch, parameters, h_y);
      diff_sigmat = diff_sigma_t(datahandle, switchingFunction, switchingPoint, y_to_switch, parameters, h_y, h_t);
      
      if Gp_flag
         diff_sigmap = diff_sigma_p(datahandle, switchingFunction, switchingPoint, y_to_switch, parameters, h_p);
      end
      
      % Evaluate the RHS at the switching point first with the model fixed on the left of the switch, then increase the model number
      % and evalate the RHS with the model fixed on the left of the switch. 
      fminus = functionRHS(datahandle, switchingPoint, y_to_switch, parameters);
      
      data = datahandle.getData();
      data.computeSensitivity.modelStage = data.computeSensitivity.modelStage + 1;
      datahandle.setData(data);
      
      fplus = functionRHS(datahandle, switchingPoint, y_to_switch, parameters);
      
      % Calculate the updates according to the update formula 
      Updates.Uy_new{save} = unit + (fplus - fminus) * diff_sigmay / diff_sigmat;
      
      if Gp_flag
         Updates.Up_new{save} = (fplus - fminus) * diff_sigmap / diff_sigmat;
      end
      
      save = save + 1;
   end
   
end