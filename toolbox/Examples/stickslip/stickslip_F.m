function F = stickslip_F(x, vrel, Fs, k, epsilon) 
  if abs(vrel) < epsilon
     F = min(abs(k*x), Fs) * sign(k*x);
  else
     F = -Fs * vrel;
  end
end