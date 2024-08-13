function Gy_t_ts = generateGmatrices_Gy_t_ts(datahandle, sol, sensData, options)
   % Gy_t_ts = generateGmatrices_Gy_t_ts(datahandle, sol, sensData, options)
   %
   % Calculates the concluding G-matrix (that is needed to put together the sensitivity w.r.t. y0 with the calculated updates)
   % which is the sensitivity at the timpoint t (t stands for the timpoints at which the sensitivities should be calculated)
   % while the starting point is the preceding swtiching point (called ts).
   %
   % INPUT: datahandle - datahandle you get from the integration process with solveODE
   %        sol        - solution object from the integration with solveODE
   %        sensData   - struct that contains the timepoints, the modelNum and the sensitivities at the given timepoints w.r.t. y0 and p
   %        options    - struct that has the informations for the stepsizes for END, the integrator and the method
   %
   % Gy_t_ts - cell-array that contains the sensitivitiies w.r.t. y0 at the timpoint t (t stands for the timpoints
   % at which the sensitivities should be calculated) while the starting point is the preceding swtiching point (called ts)
   
   % Initialize
   data = datahandle.getData();
   timepoints = sensData.timepoints;
   switches = data.computeSensitivity.switches_extended;
   y_to_switches = data.computeSensitivity.y_to_switches;
   modelNum = sensData.modelNum;
   
   dim_y = data.computeSensitivity.dim_y;
   tspan_new = [switches(modelNum), timepoints(end)];
   unit_y = eye(dim_y);
   
   Gy_t_ts = cell(1, length(timepoints));

   if options.method == options.methodCoded.END_piecewise
      FDstep = options.FDstep;
      y_start = y_to_switches(:, modelNum);
      h_y = fdStep_getH_y(FDstep, y_start);
      [sol_original, sols_disturbed] = solveDisturbed_Gy(datahandle, tspan_new, modelNum, y_start, h_y, options);
      y  = repmat(deval(sol_original,timepoints), [1, dim_y]);
      % Cycle through every initial value and compute the sensitivites
      eval_disturb_y0 = cell(1, dim_y);
      for j=1:dim_y
         sol_disturb = sols_disturbed{j};
         eval_disturb_y0{j} = deval(sol_disturb,timepoints);
      end
      
      difference = reshape((cell2mat(eval_disturb_y0) - y), [], dim_y);
      
      count = 1 : dim_y : size(difference, 1);
      for i = 1:length(timepoints)
         Gy_t_ts{i} = difference(count(i):i*dim_y, 1:dim_y)./reshape(h_y, 1, []);
      end
      if timepoints(1) == switches(modelNum)
         % at the switch, the sensitivity is eye. Since we applied our h-disturbance to y, though,
         % our END solution will not reflect this. So, correct the first time point's value.
         Gy_t_ts{1} = unit_y;
      end
   else
      
      % Calculate the G-matrix Gy_t_ts for the update formula using variational differential equations
      solVDE = solveVDE_Gy(datahandle, sol, tspan_new, modelNum, options);      
      diff_y_y0_sol = deval(solVDE, timepoints);
      
      for i = 1:length(timepoints)
         Gy_t_ts{i} = reshape(diff_y_y0_sol(:,i), dim_y, []);
      end   
   end
   
end