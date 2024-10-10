function dy_y0 = compute_sensitivity_ENDfull_y(datahandle, sol, t_sort_unique, FDstep, directions_y)
   % dy_y0 = compute_sensitivity_ENDfull_y(datahandle, sol, t_sort_unique, FDstep, directions_y)
   %
   % Calculates the sensitivity with respect to the initival value y0 at a given time point t using solveODE
   %
   % INPUT: datahandle    - datahandle you get from the integration process with solveODE
   %        sol           - solution object from the integration with solveODE
   %        t_sort_unique - sorted timepoints where you want to calculate the sensitivity with respect to p using END
   %        FDstep        - struct with necessary information for the stepsize for calcualtion of derivatives with END
   %        directions_y  - matrix that contains the directions in which you want to calculate the derivatives
   %
   % OUTPUT: dy_y0 - matrix containing the sensitivities with respect to y0
   
   % Initialize
   data = datahandle.getData();
   
   tspan = data.SWP_detection.tspan;
   initialvalues = data.SWP_detection.initialvalues;
   parameters = data.SWP_detection.parameters;
   
   dim_y = length(initialvalues);
   length_t = length(t_sort_unique);
   h_y = FDstep.dir;
   
   % If no directions for directional derivatives were given then the usual sensitivities are calculated
   if isscalar(directions_y) && directions_y == 0
      directions_y = eye(dim_y);
      h_y = fdStep_getH_y(FDstep, initialvalues);
   end
   
   dim_directions_y = size(directions_y, 2);

   eval_disturb_y0 = cell(1, dim_directions_y); 
   dy_y0 = cell(1, length_t);
   
   y = repmat(deval(sol,t_sort_unique), [1, dim_directions_y]);
   
   tspan_new = [tspan(1), t_sort_unique(end)];
   
   % Cycle though all the given directions and compute the directional derivatives if directions were given or the usual sensitivites
   for j=1:dim_directions_y
      sol_disturb = solveODE(datahandle, tspan_new, initialvalues + h_y.*directions_y(:,j), parameters);
      eval_disturb_y0{j} = deval(sol_disturb,t_sort_unique);
   end
   
   diff = reshape((cell2mat(eval_disturb_y0) - y), [], dim_directions_y);
   
   count = 1 : dim_y : size(diff, 1);
   for i = 1:length_t
      dy_y0{i} = diff(count(i):i*dim_y, 1:dim_directions_y)./reshape(h_y, 1, []);
   end
   if t_sort_unique(1) == tspan(1)
       % G(t_0, t_0) = directions_y. But since we apply our disturbance to the initial value, our solution will not
       % reflect this. So, just force dy_y0{1} = directions_y in this special case.
       dy_y0{1} = directions_y;
   end
   
   % Set pertubaded values to the initial ones to be able to use the datahandle with the original data again
   data = datahandle.getData();
   data.SWP_detection.initialvalues = initialvalues;
   data.SWP_detection.tspan = tspan;
   datahandle.setData(data);
end