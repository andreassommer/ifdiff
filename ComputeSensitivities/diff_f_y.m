function df_y = diff_f_y(functionRHS_simple, t, y, parameters, h)
   % df_y = diff_f_y(functionRHS_simple, t, y, parameters, h)
   %
   % Calculates the derivative of the RHS with respect to y usind END (External numerical Differentiation)
   %
   % INPUT: functionRHS_simple - RHS-function of the initial ODE solved with solveODE
   %        t                  - current time point where you need the integrator to calculate the solution of the VDE
   %        y                  - y-value corresponding to the time point t
   %        parameters         - parameters of the RHS of the ODE solved with solveODE
   %        h                  - stepsize for calcualtion of derivatives with END (External numerical differentiation)
   %
   % OUTPUT: df_y - derivative of the RHS with respect to y
   
   dim_y    = length(y);
   df_y = zeros(dim_y);
   unit = eye(dim_y);
   
   for i = 1:dim_y
      df_y(:,i) = ( functionRHS_simple(t, y, parameters) - functionRHS_simple(t, y-h.*unit(:,i), parameters) ) / h(i);
   end
end