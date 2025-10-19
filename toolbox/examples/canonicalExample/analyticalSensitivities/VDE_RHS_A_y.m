function dG = VDE_RHS_A_y(t, G)
   %Exact RHS function for VDEs w.r.t. initial values according to model A
   df_y = zeros(2);
   
   G_matrix = reshape(G, size(df_y));
   dG_matrix = df_y * G_matrix;
   
   dG = reshape(dG_matrix, [], 1);
end