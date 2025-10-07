function T = fun_T1(v)
 
   p = nysscc_getPhysicsParameters();
   
   tmp = 1 ./ (0.1 * p.gamma * v - 0.3);
   
   T = p.B01  +  p.B11 * tmp  +  p.B21 * tmp.^2  +  p.B31 * tmp.^3  +  p.B41 * tmp.^4  +  p.B51 * tmp.^5; 

end