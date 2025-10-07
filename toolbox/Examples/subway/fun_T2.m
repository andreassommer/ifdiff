function T = fun_T2(v)
 
   p = nysscc_getPhysicsParameters();
   
   tmp = 1 ./ (0.1 * p.gamma * v - 1.0);
   
   T = p.B02  +  p.B12 * tmp  +  p.B22 * tmp.^2  +  p.B32 * tmp.^3  +  p.B42 * tmp.^4  +  p.B52 * tmp.^5; 

end