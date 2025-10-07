function df_p = diff_f_p_naiv(functionRHS, t, y, parameters, h)
  %Computation of derivatives of the RHS function w.r.t. p using finite differences without switching point considerations
  
   dim_p = length(parameters);
   dim_y = length(y);
   df_p = zeros(dim_y, dim_p);
   unit = eye(dim_p);
   
   for i = 1:dim_p
      df_p(:,i) = ( functionRHS(t, y, parameters+h.*unit(:,i)) - functionRHS(t, y, parameters) ) / h;
   end
end