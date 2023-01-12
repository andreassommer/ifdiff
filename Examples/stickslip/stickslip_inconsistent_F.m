function F = stickslip_inconsistent_F(x, vrel, Fs, k, epsilon, delta)
 
  if abs(vrel) < epsilon
     F = min(abs(k*x), Fs) * sign(k*x);
  else
     F = -Fs * sign(vrel) / (1 + delta*abs(vrel));
  end

end