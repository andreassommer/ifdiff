function L = fun_L1(x)

   p = nysscc_getPhysicsParameters();
   
   tmp = 1 ./ (0.1 * p.gamma * x);
   
   L = p.C01  +  p.C11 * tmp  +  p.C21 * tmp.^2  +  p.C31 * tmp.^3  +  p.C41 * tmp.^4  +  p.C51 * tmp.^5;
   
end