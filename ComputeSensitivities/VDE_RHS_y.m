function dG = VDE_RHS_y(datahandle, sol, functionRHS, t, G, parameters, options)
   % dG = VDE_RHS_y(sol, functionRHS_simple, t, G, parameters, options)
   %
   % Calculates the RHS of the VDE (Variaional differential equation) for the sensitivity calculation
   % with respect to y0
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

   y = deval(sol, t);
   FDstep = options.FDstep;
   h_y = fdStep_getH_y(FDstep, y);
   
   % Calculate the derivative of the RHS w.r.t. y 
   df_y = del_f_del_y(datahandle, functionRHS, t, y, parameters, h_y);
   
   G_matrix = reshape(G, size(df_y));
   dG_matrix = df_y * G_matrix;
   
   dG = reshape(dG_matrix, [], 1);
end