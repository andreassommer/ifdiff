function dG = VDE_RHS_p(sol, functionRHS_simple, t, G, parameters, options)
   % dG = VDE_RHS_p(sol, functionRHS_simple, t, G, parameters, options)
   %
   % Calculates the RHS of the VDE (Variaional differential equation) for the sensitivity calculation
   % with respect to p
   %
   % INPUT: sol                - solution object from the integration with solveODE
   %        functionRHS_simple - RHS-function of the initial ODE solved with solveODE
   %        t                  - current time point where you need the integrator to calculate the solution of the VDE
   %        G                  - sensitivity matrix with respect to y0 at the time point t
   %        parameters         - parameters of the RHS for the initial ODE solved with solveODE
   %        options            - struct that includes the struct FDstep with the stepsizes
   %                             for calcualtion of derivatives with END (External numerical differentiation)
   %
   % OUTPUT: dG - matrix that represents the RHS of the VDE shaped as a vector for further calculations
   
   % Initialize
   y = deval(sol, t);
   FDstep = options.FDstep;
   
   % Set the step size for calculating finite differences. It can be either calculated relativ to the point where you are calculating
   % the derivative or it can be set to an absolute value.
   if FDstep.y_rel
      point_y = abs(y);
      h_y = max(FDstep.y_min, point_y .* FDstep.y);
   else
      h_y = FDstep.y;
   end
   
   if FDstep.p_rel
      point_p = abs(parameters);
      h_p = max(FDstep.p_min, point_p .* FDstep.p);
   else
      h_p = FDstep.p;
   end
   
   % Calculate the derivatives of the RHS w.r.t. y and p
   df_y = diff_f_y(functionRHS_simple, t, y, parameters, h_y);
   df_p = diff_f_p(functionRHS_simple, t, y, parameters, h_p);
   
   G_matrix = reshape(G, size(df_p));
   dG_matrix = df_y * G_matrix + df_p;
   
   dG = reshape(dG_matrix, [], 1);
end