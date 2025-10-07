function val = funinif_rhs(t,y,~)
  if t > funinif_ext(t,y)
     val = 1;
  else
     val = 1.1;
  end
end