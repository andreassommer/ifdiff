function dsigma_p = diff_sigma_p(datahandle, switchingFunction, t, y, parameters, h)
   % dsigma_p = diff_sigma_p(datahandle, switchingFunction, t, y, parameters, h)
   %
   % Calculates the derivative of the RHS with respect to the parameters p usind END (External numerical Differentiation)
   %
   % INPUT: datahandle        - datahandle you get from the integration process with solveODE
   %        switchingFunction - switching function for which you want the derivative with respect to p
   %        t                 - time point at which you want to calculate the derivative
   %        y                 - y-value corresponding to the time point t
   %        parameters        - parameters of the RHS of the ODE solved with solveODE
   %        h                 - stepsize for calcualtion of derivatives with END (External numerical differentiation)
   %
   % OUTPUT: dsigma_p - derivative of the RHS with respect to p
   
   % Initialize
   dim_p = length(parameters);
   unit = eye(dim_p);
   dsigma_p = zeros(1,dim_p);
   
   for i = 1:dim_p
      dsigma_p(1,i) = ( switchingFunction(datahandle, t, y, parameters + h.*unit(:,i)) - switchingFunction(datahandle, t, y, parameters) ) / h(i);
   end
end
  