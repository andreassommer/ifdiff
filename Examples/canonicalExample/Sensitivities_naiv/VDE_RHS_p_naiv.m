function dG = VDE_RHS_p_naiv(sol, functionRHS, t, G, parameters)
   %RHS function for VDEs w.r.t. parameters without swithing point detection
   
   % Initialize
   y = deval(sol, t);
   h=1-6;
   
   % Calculate the derivatives of the RHS w.r.t. y and p
   df_y = diff_f_y_naiv(functionRHS, t, y, parameters, h);
   df_p = diff_f_p_naiv(functionRHS, t, y, parameters, h);
   
   G_matrix = reshape(G, size(df_p));
   dG_matrix = df_y * G_matrix + df_p;
   
   dG = reshape(dG_matrix, [], 1);
end