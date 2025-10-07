function dG = VDE_RHS_B_y(t, G)
   %Exact RHS function for VDEs w.r.t. initial values according to model B
    
   switch_1 = nthroot(1331.1,3);
   yB_2 = @(t) 5*(t - switch_1);

   
   df_y = [0 3*yB_2(t)^2; 0 0];
   
   G_matrix = reshape(G, size(df_y));
   dG_matrix = df_y * G_matrix;
   
   dG = reshape(dG_matrix, [], 1);
end