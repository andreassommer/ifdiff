function dG = VDE_RHS_C_y(t, G)
   %Exact RHS function for VDEs w.r.t. initial values according to model C
   
   switch_1 = nthroot(1331.1,3);
   yB_1 = @(t) 125*( (1/4)*t.^4 + (1/37500)*t.^3 - (switch_1)*t.^3 + (3/2)*(switch_1)^2*t.^2 - 1331.1*t - (1/37500)*1331.1 - (7/4)*(switch_1)^4 + 2662.2*(switch_1)) + 5.437;
   yB_2 = @(t) 5*(t - switch_1);
   switching_function_2 = @(t) 5.437 + 0.5 - yB_1(t);
   switch_2 = fzero(switching_function_2,11);
   
   df_y = [0 3*yB_2(switch_2)^2; 0 0];
   
   G_matrix = reshape(G, size(df_y));
   dG_matrix = df_y * G_matrix;
   
   dG = reshape(dG_matrix, [], 1);
end