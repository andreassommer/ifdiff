function dy_p = compute_sensitivity_ENDfull_p(datahandle, sol, t_sort_unique, FDstep, directions_p)
   % dy_p = compute_sensitivity_ENDfull_p(datahandle, sol, t_sort_unique, FDstep, directions_p)
   %
   % Calculates the sensitivity with respect to the parameters p at a given time point t using solveODE
   %
   % INPUT: datahandle    - datahandle you get from the integration process with solveODE
   %        sol           - solution object from the integration with solveODE
   %        t_sort_unique - sorted timepoints where you want to calculate the sensitivity with respect to p using END
   %        FDstep        - struct with necessary information for the stepsize for calcualtion of derivatives with END
   %        directions_p  - matrix that contains the directions in which you want to calculate the derivatives
   %
   % OUTPUT: dy_p - matrix containing the sensitivities with respect to p
   
   % Initialize
   data = datahandle.getData();
   
   tspan = data.SWP_detection.tspan;
   initialvalues = data.SWP_detection.initialvalues;
   parameters = data.SWP_detection.parameters;
   
   dim_y = length(initialvalues);
   dim_p = length(parameters);
   h_p = FDstep.dir;
   
   % If no directions for directional derivatives were given then the usual sensitivities are calculated
   if isscalar(directions_p) && directions_p == 0
      directions_p = eye(dim_p);
      h_p = fdStep_getH_p(FDstep, parameters);
   end
   
   dim_directions_p = size(directions_p, 2);
   
   eval_disturb_p = cell(1, dim_directions_p); 
   dy_p = cell(1, length(t_sort_unique));

   y = repmat(deval(sol,t_sort_unique), [1, dim_directions_p]);
   
   tspan_new = [tspan(1), t_sort_unique(end)];
   
   % Cycle through all the given directions and compute the directional derivatives if directions were given or the usual sensitivites
   for j=1:dim_directions_p
      sol_disturb = solveODE(datahandle, tspan_new, initialvalues, parameters + h_p.*directions_p(:,j));
      eval_disturb_p{j} = deval(sol_disturb,t_sort_unique);
   end
   
   diff = reshape((cell2mat(eval_disturb_p) - y), [], dim_directions_p);
   
   count = 1 : dim_y : size(diff, 1);
   for i = 1:length(t_sort_unique)
      dy_p{i} = diff(count(i):i*dim_y, 1:dim_directions_p)./reshape(h_p, 1, []);
   end
   if t_sort_unique(1) == tspan(1)
       % Gp(t_0, t_0)=0. But since we apply our h-disturbance to the initial values, our solution will not reflect
       % this. Here, we correct this case.
       dy_p{1} = zeros(dim_y, dim_directions_p);
   end
   
   % Set pertubaded values to the initial ones to be able to use the datahandle with the original data again
   data = datahandle.getData();
   data.SWP_detection.parameters = parameters;
   data.SWP_detection.tspan = tspan;
   datahandle.setData(data);
end