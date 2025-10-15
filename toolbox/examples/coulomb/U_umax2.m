function U = U_umax2(t)
% Optimum contol (voltage), precalculated

% Maximum Voltage (time-optimal solution is bang-bang)
Umax = 2;

t1 = 0.074140;
t2 = 0.0820268;
t3 = 0.101444;
t4 = 0.110420;
tf = 0.111184;

% alternative: get times from function! --> SHOULD BE TESTED!
% times = getTimes(); 
% t1 = times.t1; t2 = times.t2, t3 = times.t3; t4 = times.t4; tf = times.tf;

if (t <= t1)
   U = Umax;
elseif (t <= t2)
   U = -Umax;
elseif (t <= t3)
   U = Umax;
elseif (t <= t4)
   U = -Umax;
elseif (t <= tf)
   U = Umax;
end

end

