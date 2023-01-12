function L = fun_L2(x)

   p = nysscc_getPhysicsParameters();
   
   tmp = 1 ./ (0.1 * p.gamma * x - 1.0);
   
   L = p.C02  +  p.C12 * tmp  +  p.C22 * tmp.^2  +  p.C32 * tmp.^3  +  p.C42 * tmp.^4  +  p.C52 * tmp.^5;
   
end