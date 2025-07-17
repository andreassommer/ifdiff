function [residual_function] = generateResFunction(t, datahandle, sol, measurements, tspan, parameters_ODE, FDstep, method)
   %Generation of residual function for parameter estimation using nested functions
   
   residual_function = @computeResidual;
   dim_y = size(sol.y, 1);
   dim_p = length(parameters_ODE);
   
   return
   
   function [residual, jacobian] = computeResidual(p)
      %Residual function 
      
      initialvalues = p(dim_p+1:end);
      params = p(1:dim_p);
      sol_p = solveODE(datahandle, tspan, initialvalues, params);
      h = reshape(deval(sol_p, t), [], 1);
      
      residual = (h-measurements);
      
      % Sensitivities
      if nargout > 1
         sensitivities_function = generateSensitivityFunction(datahandle, sol_p, FDstep, 'method', method, 'p_typ', parameters_ODE);
         sensitivites = sensitivities_function(t);
         jacobian = zeros(dim_y*length(t), dim_p + dim_y);
         count = 1;
         for i = 1:dim_y:dim_y*length(t)
            jacobian(i:i+(dim_y-1),1:dim_p) = sensitivites(count).Gp;
            jacobian(i:i+(dim_y-1), (dim_p+1):end) = sensitivites(count).Gy;
            count = count + 1;
         end
      end
   end
end