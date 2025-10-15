function R = fun_R(v)
 
   p = nysscc_getPhysicsParameters();
   
   tmp = p.gamma * v;
   
   R = 116  +  1.3/2000 * p.W  +  p.b * p.W * tmp / 2000 +  p.c * p.a * tmp.^2;

end