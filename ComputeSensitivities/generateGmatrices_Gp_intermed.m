function Gp_new = generateGmatrices_Gp_intermed(datahandle, sol, startModel, endModel, options)
   % Gp_new = generateGmatrices_Gp_intermed(datahandle, sol, Gmatrices_intermediate, startModel, endModel, options)
   %
   % Calculates the intermediate G-matrices that contain the sensitivites w.r.t. p at the switching points
   % that define the model changes until endModel.
   %
   % INPUT: datahandle             - datahandle you get from the integration process with solveODE
   %        sol                    - solution object from the integration with solveODE
   %        Gmatrices_intermediate - struct that contains the already calculated intermediates and updates w.r.t. y0 and p
   %        startModel                - amount of intermediate G-matrices that already have been calculated and saved from previous function calls.
   %                                 (If startModel = 1, it means that the intermediates were only initialised and all the matrices have still to be calculated.)
   %        endModel               - number of the model until which the intermediates need to be calculated
   %        options                - struct that has the informations for the stepsizes for END, the integrator and the method
   %
   % OUTPUT: Gp_new - cell-array that contains the new calculated intermediates w.r.t. p
   
   % Initialize
   data = datahandle.getData();
   parameters = data.SWP_detection.parameters;
   switches = data.computeSensitivity.switches_extended;
   y_to_switches = data.computeSensitivity.y_to_switches;

   dim_y = data.computeSensitivity.dim_y;
   dim_p = data.computeSensitivity.dim_p;

   Gp_intermediate = cell(1, length(startModel : (endModel-1)));

   FDstep = options.FDstep;
   h_p = fdStep_getH_p(FDstep, parameters);

   % Calculate the remaining intermediate G-matrices for the update formula until endModel.
   % First the matrix Gp_ts2_ts1 need to be calculated. Here ts1 and ts2 stand for two consequtive switching points and the matrix contains
   % the sensitvities at the point ts2 with the starting time ts1. 
   for i = startModel : (endModel - 1)

      tspan_end = switches(i+1);
      tspan_new = [switches(i), tspan_end];

      if options.method == options.methodCoded.END_piecewise
         y_start = y_to_switches(:, i);
         [sol_original, sols_disturbed] = solveDisturbed_Gp(datahandle, tspan_new, i, y_start, h_p, options);
         eval_disturb_p = zeros(dim_y, dim_p);
         for j=1:dim_p
            sol_disturb = sols_disturbed{j};
            eval_disturb_p(:,j) = deval(sol_disturb, tspan_end);
         end
         y = deval(sol_original, tspan_end);
         Gp_ts2_ts1 = (eval_disturb_p - y)./ reshape(h_p, 1, []);
      else
         % Calculate the G-matrix Gp_ts2_ts1 for the update formula using variational differential equations      
         solVDE = solveVDE_Gp(datahandle, sol, tspan_new, i, options);
         Gp_ts2_ts1 = reshape(solVDE.y(:,end), dim_y, dim_p);
      end

      Gp_intermediate{i} = Gp_ts2_ts1;
   end

   Gp_new = Gp_intermediate;
end

