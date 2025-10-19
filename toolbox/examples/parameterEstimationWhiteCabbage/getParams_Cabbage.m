function parameters = getParams_Cabbage()
   %Parameters for growth of white cabbage model 
   
   parameters(1) = 34469.4; %a
   parameters(2) = 0.111250; %r_L
   parameters(3) = 0.00436115; %mu_L
   parameters(4) = 0.200796; %rho
   parameters(5) = 0.174061; %r_S
   parameters(6) = 0.280528; %r_H
   parameters(7) = 0.149658; %mu_H
   parameters(8) = 0.199102; %gamma
   parameters(9) = 60.8571; %t_H
   
   parameters = reshape(parameters, [], 1);
end