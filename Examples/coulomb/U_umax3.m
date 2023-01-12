function U = U_umax3(t)
% Optimum contol (voltage), precalculated

% Maximum Voltage (time-optimal solution is bang-bang)
Umax = 3;

t1  = 0.0416854;
tv1 = 0.04800526;  %#ok<NASGU>  % unused helper
t2  = 0.0525894;
tv2 = 0.05635593;  %#ok<NASGU>  % unused helper
t3  = 0.0786491;
t4  = 0.0878590;
tf  = 0.0886180;

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
% 
% if (t <= t1)
%     U = Umax;
%     if (t <= t2)
%         U = -Umax;
%         if (t <= t3)
%             U = Umax;
%             if (t <= t4)
%                 U = -Umax;
%                 if (t <= tf)
%                     U = Umax;
%                 end
%             end
%         end
%     end
% end 

end

