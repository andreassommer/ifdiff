function df_p = diff_f_p(functionRHS_simple, t, y, parameters, h)
   % df_p = diff_f_p(functionRHS_simple, t, y, parameters, h)
   %
   % Calculates the derivative of the RHS with respect to the parameters p usind END (External numerical Differentiation)
   %
   % INPUT: functionRHS_simple - RHS-function of the initial ODE solved with solveODE
   %        t                  - current time point where you need the integrator to calculate the solution of the VDE
   %        y                  - y-value corresponding to the time point t
   %        parameters         - parameters of the RHS of the ODE solved with solveODE
   %        h                  - stepsize for calcualtion of derivatives with END (External numerical differentiation)
   %
   % OUTPUT: df_p - derivative of the RHS with respect to the parameters p
   
   dim_p = length(parameters);
   dim_y = length(y);
   df_p = zeros(dim_y, dim_p);
   unit = eye(dim_p);
   
   for i = 1:dim_p
      df_p(:,i) = ( functionRHS_simple(t, y, parameters+h.*unit(:,i)) - functionRHS_simple(t, y, parameters) ) / h(i);
   end
end
