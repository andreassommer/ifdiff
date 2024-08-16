function dsigma_t = diff_sigma_t(datahandle, switchingFunction, t, y, parameters, h_y, h_t)
   % dsigma_t = diff_sigma_t(datahandle, switchingFunction, t, y, parameters, h_y, h_t)
   %
   % Calculates the derivative of the RHS with respect to t usind END (External numerical Differentiation)
   % Note that this is a total derivative - the contribution of t to sigma directly as well as indirectly through y(t)
   % are relevant
   %
   % INPUT: datahandle        - datahandle you get from the integration process with solveODE
   %        switchingFunction - switching function for which you want the derivative with respect to t
   %        t                 - time point at which you want to calculate the derivative
   %        y                 - y-value corresponding to the time point t
   %        parameters        - parameters of the RHS of the ODE solved with solveODE
   %        h_y, h_t          - stepsizes for calcualtion of derivatives with END (External numerical differentiation)
   %
   % OUTPUT: dsigma_t - derivative of the RHS with respect to t
   
   % Initialize
   data = datahandle.getData();
   functionRHS = data.integratorSettings.preprocessed_rhs;
   
   dsigma_t = ( switchingFunction(datahandle, t+h_t, y, parameters) - switchingFunction(datahandle, t, y, parameters) ) / h_t...
      + diff_sigma_y(datahandle, switchingFunction, t, y, parameters, h_y) * functionRHS(datahandle, t, y, parameters);
end
