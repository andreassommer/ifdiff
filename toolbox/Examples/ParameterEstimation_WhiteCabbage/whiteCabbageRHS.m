function dy = whiteCabbageRHS(t, y, p)
   %RHS for growth of white cabbage model
   
   dy = zeros(3,1);
   
   dy(1) = p(2) * (p(1) + 1)/(p(1) + exp(p(4) * t)) * y(1) - p(3) * y(1);
   
   dy(2) = p(5) * (p(8) * y(1) - y(2));
   
   if  t <= p(9)
      dy(3) = 0;
   else
      dy(3) = p(6) * y(1) - p(7) * y(3);
   end

end
