function p = getParamsAsStruct()

p.KF = 12.0;   % N/A  force constant    
%p.k  =  2.4;  % kN/m spring constant
p.k  = 2400;   % N/m  spring constant
p.KS = 12.0;   % Vs/m voltage constant
p.FR =  2.1;   % N    guide friction force
p.m1 =  1.03;  % kg   motor mass
p.m2 =  0.56;  % kg   load mass
%p.L  =  2.0;  % mH   coil inductivity
p.L  =  0.002; % H    coil inductivity
p.R  =  2.0;   % OHM  coil resistance

end