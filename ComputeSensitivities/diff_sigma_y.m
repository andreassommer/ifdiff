function dsigma_y = diff_sigma_y(datahandle, switchingFunction, t, y, parameters, h)
   % dsigma_y = diff_sigma_y(datahandle, switchingFunction, t, y, parameters, h)
   %
   % Calculates the derivative of the RHS with respect to y usind END (External numerical Differentiation)
   %
   % INPUT: datahandle        - datahandle you get from the integration process with solveODE
   %        switchingFunction - switching function for which you want the derivative with respect to y
   %        t                 - time point at which you want to calculate the derivative
   %        y                 - y-value corresponding to the time point t
   %        parameters        - parameters of the RHS of the ODE solved with solveODE
   %        h                 - stepsize for calcualtion of derivatives with END (External numerical differentiation)
   %
   % OUTPUT: df_y - derivative of the RHS with respect to y
   
   % Initialize
   dim_y = length(y);
   unit = eye(dim_y);
   dsigma_y = zeros(1,dim_y);
   
   for i = 1:dim_y
      dsigma_y(1,i) = ( switchingFunction(datahandle, t, y, parameters) - switchingFunction(datahandle, t, y-h.*unit(:,i), parameters) ) / h(i);
   end
end
  