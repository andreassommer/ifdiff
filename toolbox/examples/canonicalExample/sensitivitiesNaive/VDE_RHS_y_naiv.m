function dG = VDE_RHS_y_naiv(sol, functionRHS, t, G, parameters)
   %RHS function for VDEs w.r.t. initial values without swithing point detection  
   
   % Initialize
   y = deval(sol, t);
   h_y = 1e-6;
   
   % Calculate the derivative of the RHS w.r.t. y 
   df_y = diff_f_y_naiv(functionRHS, t, y, parameters, h_y);
   
   G_matrix = reshape(G, size(df_y));
   dG_matrix = df_y * G_matrix;
   
   dG = reshape(dG_matrix, [], 1);
end