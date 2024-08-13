function Gy_new = generateGmatrices_Gy_intermed(datahandle, sol, startModel, endModel, options)
   % Gy_new = generateGmatrices_Gy_intermed(datahandle, sol, startModel, endModel, options)
   %
   % Calculates the intermediate G-matrices that contain the sensitivites w.r.t. y0 at the switching points
   % that define the model changes until endModel.
   %
   % INPUT: datahandle - datahandle you get from the integration process with solveODE
   %        sol        - solution object from the integration with solveODE
   %        startModel - model to start with
   %        endModel   - number of the model until which the intermediates need to be calculated
   %        options    - struct that has the informations for the stepsizes for END, the integrator and the method
   %
   % OUTPUT: Gy_new - cell-array that contains the new calculated intermediates w.r.t. y
   
   % Initialize
   data = datahandle.getData();
   switches = data.computeSensitivity.switches_extended;
   y_to_switches = data.computeSensitivity.y_to_switches;
   FDstep = options.FDstep;

   dim_y = data.computeSensitivity.dim_y;

   Gy_new = cell(1, endModel - startModel);

   % Calculate the remaining intermediate G-matrices for the update formula until endModel.
   % Here ts1 and ts2 stand for two consequtive switching points and the matrix Gy_ts2_ts1 contains
   % the sensitvities at the point ts2 with the starting time ts1.
   for i = startModel : (endModel-1)

      tspan_end = switches(i+1);
      tspan_new = [switches(i), tspan_end];

      if options.method == options.methodCoded.END_piecewise
         y_start = y_to_switches(:, i);
         if FDstep.y_rel
            point_y = abs(y_start);
            h_y = max(FDstep.y_min, point_y .* FDstep.y);
         else
            h_y = FDstep.y;
         end
         [sol_original, sols_disturbed] = solveDisturbed_Gy(datahandle, tspan_new, i, y_start, h_y, options);
         y  = deval(sol_original,tspan_end);
 
         eval_disturb_y0 = zeros(dim_y);
         for j=1:dim_y
            sol_disturb = sols_disturbed{j};
            eval_disturb_y0(:,j) = deval(sol_disturb,tspan_end);
         end 
         Gy_ts2_ts1 = (eval_disturb_y0 - y)./ reshape(h_y, 1, []);

      else
         solVDE = solveVDE_Gy(datahandle, sol, tspan_new, i, options);
         Gy_ts2_ts1 = reshape(solVDE.y(:,end), dim_y, dim_y);
      end

      Gy_new{i-startModel+1} = Gy_ts2_ts1;
   end
end