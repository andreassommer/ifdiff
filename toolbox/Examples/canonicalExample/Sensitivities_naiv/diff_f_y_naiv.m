function df_y = diff_f_y_naiv(functionRHS, t, y, parameters, h)
   %Computation of derivatives of the RHS function w.r.t. y using finite differences without switching point considerations
     
   dim_y = length(y);
   df_y = zeros(dim_y);
   unit = eye(dim_y);
   
   for i = 1:dim_y
      df_y(:,i) = ( functionRHS(t, y, parameters) - functionRHS(t, y-h.*unit(:,i), parameters) ) / h;
   end
end