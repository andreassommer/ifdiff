function [residual_function] = generateResidualFunction(t, datahandle, sol, measurements, tspan, parameters_ODE, RHS, FDstep, integrator, method)
   %Generation of residual function for parameter estimation using nested functions
   
   residual_function = @computeResidual;
   dim_y = size(sol.y, 1);
   dim_p = length(parameters_ODE);
   
   integrator_solveODE = @ode45;
   odeoptionsrhs_test = odeset( 'AbsTol', 1e-14,'RelTol', 1e-6);
   datahandle    = prepareDatahandleForIntegration('whiteCabbageRHS','solver', func2str(integrator_solveODE), 'options', odeoptionsrhs_test);
   
   return
   
   function [residual, jacobian] = computeResidual(p)
      %Residual function 
      
      initialvalues = p(dim_p+1:end);
      params = p(1:dim_p);
      if strcmp(func2str(integrator), 'solveODE')
         sol_p = solveODE(datahandle, tspan, initialvalues, params);
      else
         RHS_ode45 = @(t,y) RHS(t, y, p);
         sol_p = ode45(RHS_ode45, tspan, initialvalues);
      end
      h = reshape(deval(sol_p, t), [], 1);
      
      residual = (h-measurements);%./sigma;
      
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