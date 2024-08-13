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
   length_t = length(timepoints);
   unit_y = eye(dim_y);
   
   Gy_t_ts = cell(1, length_t);
   
   % To be able to calculate the sensitivities at a switch we consider the function y(t) to be cadlag ("right continuous with left limits").
   % That means each switch is the starting time of a new model interval and the sensitivity at that point is identity matrix.
   % The same holds for the starting point t0. Then the sensitivities at a switch can be calculated as usual using the update formulas.
   save = 1;
   if timepoints(1) == switches(modelNum)
      Gy_t_ts{1} = unit_y;
      length_t = length_t - 1;
      if length_t == 0
         return
      else
         timepoints = timepoints(2:end);
         save = 2;
      end
   end

   tspan_new = [switches(modelNum), timepoints(end)];

   if options.method == options.methodCoded.END_piecewise
      y_start = y_to_switches(:, modelNum);
      FDstep = options.FDstep;
      if FDstep.y_rel
         point_y = abs(y_start);
         h_y = max(FDstep.y_min, point_y .* FDstep.y);
      else
         h_y = FDstep.y;
      end
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
      for i = 1:length_t
         Gy_t_ts{save} = difference(count(i):i*dim_y, 1:dim_y)./reshape(h_y, 1, []);
         save = save + 1;
      end
      
   else
      
      % Calculate the G-matrix Gy_t_ts for the update formula using variational differential equations
      solVDE = solveVDE_Gy(datahandle, sol, tspan_new, modelNum, options);      
      diff_y_y0_sol = deval(solVDE, timepoints);
      
      for i = 1:length_t
         Gy_t_ts{save} = reshape(diff_y_y0_sol(:,i), dim_y, []);
         save = save + 1;
      end   
   end
   
end